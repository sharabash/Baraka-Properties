# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Admin;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub begin :Private {
	my ($self, $c) = @_;

	$c->log->debug('Forcing authentication or redirection at /admin');

	unless ($c->user_exists) {
		$c->response->redirect('/login');
		return 0;
	}
	else {
		my $is_admin = $c->check_user_roles('administrator');
		my $is_manager = $c->check_user_roles('manager');

		unless ($is_admin || $is_manager) {
			$c->response->redirect('/');
			return 0;
		}
	}
	return 1;
}

sub base :Chained('/') :PathPart('admin') :CaptureArgs(0) {
	my ($self, $c) = @_;
	my $is_admin = $c->check_user_roles('administrator');
	my $is_manager = $c->check_user_roles('manager');
	$c->stash(
		is_admin => $is_admin,
		is_manager => $is_manager
	);
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;

	$c->stash(
		buildings => scalar($c->model('DB::Building')->search(undef, {
			order_by => 'name',
			cache => 0
		})),
		template => 'admin/index.html'
	);
}

1;
