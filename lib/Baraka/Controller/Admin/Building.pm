# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Admin::Building;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base :Chained('/admin/base') :PathPart('building') :CaptureArgs(0) {}

sub id :Chained('/admin/base') :PathPart('building') :CaptureArgs(1) {
	my ($self, $c, $building_id) = @_;

	if ($building_id !~ /^\d+$/) {
		$c->detach('/');
		return;
	}
	else {
		$c->stash->{building} = $c->model('DB::Building')->find({ building_id => $building_id });
	}
}

sub index :Chained('id') :PathPart('') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{template} = 'admin/building/index.html';
}

sub create :Chained('base') :PathPart('create') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST' and $c->check_any_user_role(qw/administrator manager/)) {
		my $name = $c->request->params->{name};

		if ($name) {
			my $building = $c->model('DB::Building')->find_or_create({ name => $name }) or die $!;

			$c->response->redirect('/admin/building/'. $building->building_id .'/details');
		}
		else {
			$c->response->redirect("/admin");
		}
	}
	else {
		$c->response->redirect('/');
	}
}

1;
