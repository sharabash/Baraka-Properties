# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Picture::Update;

use strict;
use warnings;
use parent 'Catalyst::Controller';

# force authentication past /admin
sub auto :Private {
	my $self = shift;
	my ($c, @args) = @_;

	unless ($c->user_exists) {
		$c->flash->{message} = "Please authenticate before attempting to use this page...";
		$c->session->{referer} = $c->request->uri;
		$c->response->redirect('/login');
		return 0;
	}
	unless ($c->check_any_user_role(qw/administrator manager/)) {
		$c->flash->{message} = "You are not authorized to use this page...";
		$c->response->redirect('/');
		return 0;
	}
	return 1;
}

# match /picture/*/update
sub base :Chained('/picture/base') :PathPart('update') :CaptureArgs(0) {
	my $self = shift;
	my ($c, @args) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	if ($c->request->method eq 'POST') {
		$c->flash->{message} = $self->handle_post(@_);
	}

	$c->stash->{picture} = $c->model('DB::Picture')->find({
		picture_id => $c->stash->{picture_id}
	},{
		columns => [qw/picture_id label description type category filename/],
	});

	$c->stash->{belongs_to} = do {
		my $belongs_to = undef;
		if ($c->stash->{picture}->units->first) {
			$belongs_to = $c->stash->{picture}->units->first->building;
			$c->stash->{belongs_to_class} = 'units';
		}
		elsif ($c->stash->{picture}->buildings) {
			$belongs_to = $c->stash->{picture}->buildings->first;
			$c->stash->{belongs_to_class} = 'building';
		}
		$belongs_to;
	};

	$c->stash(
		template => 'picture/update.html'
	);

	#$c->controller('Root')->_repl(@_);
}

sub handle_post :Private {
	my $self = shift;
	my ($c, @args) = @_;

	my $return_msg = 'Updating...';
	my $picture = $c->model('DB::Picture')->find({
		picture_id => $c->request->params->{picture_id}
	});

	$c->log->debug("id ". $picture->id);

	my @params = qw/label description type category filename/;

	my $original_filename = $picture->filename;
	my $updated_filename = $c->request->params->{filename};

	for (@params) {
		my $key = $_;
		my $val = $c->request->params->{$_};
		if ($picture->$_ ne $val) {
			$c->log->debug("update $key to $val");
			$picture->update({ $key => $val });
		}
	}

	if ($c->request->params->{belongs_to_units}) {
		$c->model('DB::UnitPicture')->search({
			picture_id => $picture->id })->delete;
		if (ref($c->request->params->{belongs_to_units}) eq 'ARRAY') {
			for (@{$c->request->params->{belongs_to_units}}) {
				$c->model('DB::UnitPicture')->update_or_create({
					unit_id => $_,
					picture_id => $picture->id
				});
			}
		}
		else {
			$c->model('DB::UnitPicture')->update_or_create({
				unit_id => $c->request->params->{belongs_to_units},
				picture_id => $picture->id
			});
		}
	}
	my $still_exists = $c->model('DB::UnitPicture')->search({
		picture_id => $picture->id
	}) || $c->model('DB::BuildingPicture')->search({
		picture_id => $picture->id
	}) || do {
		$picture->delete;
		0;
	};

	if (
		$original_filename ne $updated_filename &&
		$picture->filename eq $updated_filename
	) {
		$c->response->redirect("/picture/$updated_filename/update");
	}

	return $return_msg;
}

1;
