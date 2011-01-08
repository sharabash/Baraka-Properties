# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Admin::Building::Pictures;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base :Chained('/admin/building/id') :PathPart('pictures') :CaptureArgs(0) {}
sub pictures :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST') {

		my $upload = $c->request->upload('picture');

		if ($upload) {
			use Image::Magick;

			my $image    = Image::Magick->new;
			my $filename = $upload->filename;
			my $picture  = $upload->slurp;

			$image->BlobToImage($picture);

			my $filesize = $image->Get('filesize');
			my $mime     = $image->Get('mime');
			my $width    = $image->Get('width');
			my $height   = $image->Get('height');
			my $aspect   = $width / $height;

			if ($filesize >= 1000000) {
				$image->Scale(width => 1024, height => 1024 / $aspect);

				$picture = $image->ImageToBlob();

				$image->BlobToImage($picture);

				$filesize = $image->Get('filesize');
				$width    = $image->Get('width');
				$height   = $image->Get('height');
			}

			my $dbh = DBI->connect('dbi:Pg:dbname=baraka;user=baraka', 'baraka', 'baraka', { pg_bool_tf => 0, pg_enable_utf8 => 1, AutoCommit => 1, RaiseError => 1 });
			my $sql;

			if ($c->model('DB::Picture')->find({ filename => $filename })) {
				$sql = 'UPDATE picture SET filesize = ?, mime = ?, width = ?, height = ?, picture = ? WHERE filename = ?';
			}
			else {
				$sql = 'INSERT INTO picture ( filesize, mime, width, height, picture, filename ) VALUES ( ?, ?, ?, ?, ?, ? )';
			}
			my $sth = $dbh->prepare($sql);

			$sth->bind_param(1, $filesize);
			$sth->bind_param(2, $mime);
			$sth->bind_param(3, $width);
			$sth->bind_param(4, $height);
			$sth->bind_param(5, $picture, { pg_type => DBD::Pg::PG_BYTEA });
			$sth->bind_param(6, $filename);
			$sth->execute;
			$sth->finish;

			my ($picture_id) = $dbh->selectrow_array("SELECT picture_id FROM picture WHERE filename = ". $dbh->quote($filename));

			$c->model('DB::BuildingPicture')->update_or_create({
				building_id => $c->stash->{building}->building_id,
				picture_id => $picture_id
			});

			$c->log->debug('after post');

			$c->response->redirect('/admin/building/'. $c->stash->{building}->building_id .'/pictures');
		}
	}

	$c->stash(
		template => 'admin/building/pictures.html',
		pictures => scalar($c->stash->{building}->pictures->search(undef, {
			order_by => 'filename',
			columns => [qw/picture_id filename label/]
		}))
	);
}

sub id :Chained('/admin/building/id') :PathPart('pictures') :CaptureArgs(1) {
	my ($self, $c, $picture_id) = @_;

	if ($picture_id !~ /^\d+$/) {
		$c->detach('/');
		return;
	}
	else {
		$c->stash->{picture} = $c->model('DB::Picture')->find({ picture_id => $picture_id });
	}
}

sub delete :Chained('id') :PathPart('delete') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST') {
		$c->stash->{picture}->delete;
	}

	$c->response->redirect('/admin/building/'. $c->stash->{building}->building_id .'/pictures');
}

1;
