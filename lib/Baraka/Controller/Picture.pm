# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Picture;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use POSIX qw/ceil floor/;

# match /picture
sub root :Chained('/') :PathPart('picture') :CaptureArgs(0) {
	my $self = shift;
	my ($c, @args) = @_;
}
# match /picture/*
sub base :Chained('/') :PathPart('picture') :CaptureArgs(1) {
	my $self = shift;
	my ($c, @args) = @_;
	my $filename = shift @args;

	if ($filename =~ /^(.+)\.w([\d]+)\.h([\d]+)\.([^.]+)$/) {
		$filename = "$1.$4";
		$c->stash->{width}  = $2;
		$c->stash->{height} = $3;
	}
	elsif ($filename =~ /^(.+)\.w([\d]+)\.([^.]+)$/) {
		$filename = "$1.$3";
		$c->stash->{width}  = $2;
	}
	elsif ($filename =~ /^(.+)\.h([\d]+)\.([^.]+)$/) {
		$filename = "$1.$3";
		$c->stash->{height}  = $2;
	}
	elsif ($filename =~ /^(.+)\.([^.]+)$/) {
		$filename = "$1.$2";
	}
	else {
		die "bad filename $filename (base)";
	}

	$c->stash->{picture_url} = "/picture/$filename";
	$c->stash->{picture} = $c->model('DB::Picture')->find({ filename => $filename }, {
		select => [qw/width height filename mime picture/],
		cache => 1
	});
}

# match /picture/* and display
sub _index :Chained('base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	my $params = $c->request->params;
	my $picture = $c->stash->{picture};
	my $filename = $c->stash->{filename};
	my ($width, $height) = ($c->stash->{width}, $c->stash->{height});

	if ($picture) {
		my $o_width = $picture->width;
		my $o_height = $picture->height;
		my $aspect = $o_width / $o_height;

		if ($width and not $height) {
			$height = $width / $aspect;
		}
		elsif ($height and not $width) {
			$width = $height * $aspect;
		}
		else {
			$width = $o_width;
			$height = $o_height;
		}

		$width = floor($width);
		$height = floor($height);


		my $on_disk = $c->config->{home} .'/root/static/img/cache/';

		$c->log->debug($on_disk);

		my $new_filename = $picture->filename;
		$new_filename =~ s/^(.+)\.([^.]+)$/$1.$width.$height.$2/;
		$on_disk .= $new_filename;

		$c->log->debug($on_disk);

		my $blob;

		if (!-e $on_disk) {
			use Image::Magick;

			my $image = Image::Magick->new;

			$blob = $picture->picture;

			$image->BlobToImage($blob);
			$image->Scale(width => $width, height => $height);
			#$image->AutoLevel(channel => 'All');
			my $filename = $on_disk;
			open(IMAGE, ">$filename");
			$image->Write(file => \*IMAGE, filename => $filename);
			close(IMAGE);

			$blob = $image->ImageToBlob();
			$c->log->debug("BLOB = IMAGE MAGICK : $on_disk");
		}
		else {
			open BLOB, "<$on_disk" or die "Can't open $on_disk - $!";
			{
				local $/ = undef;
				$blob = <BLOB>;
			}
			close BLOB;
			$c->log->debug("BLOB = ON DISK : $on_disk");
		}

		$c->response->content_type($picture->mime);
		$c->response->body($blob);
	}
	else {
		$c->response->body('foo :(');
		$c->log->debug('bar baz');
	}
}

sub delete :Chained('base') :PathPart('delete') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;
	if (
		$c->request->method eq 'POST' &&
		$c->check_any_user_role(qw/administrator manager/)
	) {
		my $picture = $c->model('DB::Picture')->find({ picture_id => $c->stash->{picture_id} });
		$picture->delete;
		$c->flash->{message} = "Picture deleted";
		$c->response->body("Picture deleted");
	}
}

1;
