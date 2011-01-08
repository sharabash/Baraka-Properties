# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Admin::Building::Delete;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base :Chained('/admin/building/id') :PathPart('delete') :CaptureArgs(0) {}
sub delete :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST' and $c->check_user_roles('administrator')) {
		$c->stash->{building}->delete;
	}

	$c->response->redirect('/admin');
}

1;
