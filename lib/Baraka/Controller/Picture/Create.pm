# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Picture::Create;

use utf8;
use Encode qw/encode decode/;
use DBI;
use DBD::Pg qw/:pg_types/;
use POSIX qw/ceil floor/;
use strict;
use warnings;
use parent 'Catalyst::Controller';

sub building_base :Chained('/picture/root') :PathPart('create') :CaptureArgs(1) {
	my $self = shift;
	my ($c, @args) = @_;

	my $identifier = pop @args;
	my $building_id = undef;
	if ($identifier =~ /^\d+$/) {
		$building_id = $identifier if $c->model('DB::Building')->find({ building_id => $identifier });
	}
	if (!defined $building_id) {
		$c->detach('/');
		return;
	}
	else {
		$c->stash->{building_id} = $building_id;
	}
}

sub create_building :Chained('building_base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	if (
		$c->request->method eq 'POST' &&
		$c->check_any_user_role(qw/administrator manager/)
	) {
		my $picture_id = $self->handle_upload(@_);
		$c->model('DB::BuildingPicture')->update_or_create({
			building_id => $c->stash->{building_id},
			picture_id => $picture_id
		}) if $picture_id;
	}
	else {
		$c->flash->{message} = "No.";
	}

	my $referer = $c->request->referer;
	$c->response->redirect($referer);
}

sub unit_base :Chained('building_base') :PathPart('') :CaptureArgs(1) {
	my $self = shift;
	my ($c, @args) = @_;

	my $identifier = pop @args;
	my $unit_id = undef;

	my $building = $c->model('DB::Building')->find({ building_id => $c->stash->{building_id} });
	die "Building????" unless $building;
	my $unit = $building->units->find({ unit_id => $identifier });
	$unit_id = $unit->unit_id if $unit;

	if (defined $unit_id) {
		$c->stash->{unit_id} = $unit_id;
	} else {
		die "Couldn't identify unit belonging to ". $building->name ."with $identifier";
	}
}

sub create_unit :Chained('unit_base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	if (
		$c->request->method eq 'POST' &&
		$c->check_any_user_role(qw/administrator manager/)
	) {
		my $picture_id = $self->handle_upload(@_);
		$c->model('DB::UnitPicture')->update_or_create({
			unit_id => $c->stash->{unit_id},
			picture_id => $picture_id
		}) if $picture_id;
	}
	else {
		$c->flash->{message} = "No.";
	}

	my $referer = $c->request->referer;
	$c->response->redirect($referer);
}

sub handle_upload :Private {
	my $self = shift;
	my ($c, @args) = @_;
	my $picture_id;
	if (my $upload = $c->request->upload('picture')) {
		use Image::Magick;

		my $filename = lc($upload->filename);
		my $picture = $upload->slurp;
		my $image = Image::Magick->new;

		$image->BlobToImage($picture);

		my $filesize = $image->Get('filesize');
		my $width = $image->Get('width');
		my $height = $image->Get('height');
		my $mime = $image->Get('mime');
		my $aspect = $width/$height;

		if ($width >= 2048) {
			$image->Scale(width => 2048, height => 2048/$aspect);
			$picture = $image->ImageToBlob();
			$image->BlobToImage($picture);
			$filesize = $image->Get('filesize');
			$width = $image->Get('width');
			$height = $image->Get('height');
		}

		$c->log->debug("filename $filename");
		$c->log->debug("filesize $filesize");
		$c->log->debug("width $width");
		$c->log->debug("height $height");
		$c->log->debug("mime $mime");

		if ($c->model('DB::Picture')->find({ filename => $filename })) {
			$c->flash->{message} = "$filename exists; rename or remove the existing picture to use this filename.";
			my $referer = $c->request->referer;
			$c->response->redirect($referer);
			return undef;
		}

		my $dbh = DBI->connect('dbi:Pg:dbname=baraka;user=baraka', 'baraka', 'baraka',
			{ pg_bool_tf => 0, pg_enable_utf8 => 1, AutoCommit => 1, RaiseError => 1 });
		my $insert = $dbh->prepare(
			'INSERT INTO picture ( filename, filesize, mime, width, height, picture )
			 VALUES ( ?, ?, ?, ?, ?, ? )'
		 );
		 $insert->bind_param(1, $filename);
		 $insert->bind_param(2, $filesize);
		 $insert->bind_param(3, $mime);
		 $insert->bind_param(4, $width);
		 $insert->bind_param(5, $height);
		 $insert->bind_param(6, $picture, { pg_type => DBD::Pg::PG_BYTEA });
		 $insert->execute;
		 my @row = $dbh->selectrow_array(
			"SELECT picture_id FROM picture
			 WHERE filename = ". $dbh->quote($filename) ."
			 AND mime = ". $dbh->quote($mime) ."
			 AND filesize = $filesize
			 AND width = $width
			 AND height = $height"
		 );
		 $picture_id = $row[0];
	}
	return $picture_id;
}

1;
