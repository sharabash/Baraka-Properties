# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Logout;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(0) {
	my ($self, $c) = @_;

	$c->logout;
	$c->response->redirect('/');
}

1;
