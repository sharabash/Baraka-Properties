# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

# match /login
sub base :Chained('/') :PathPart('login') :CaptureArgs(0) {}

# match /login (end of chain)
sub _index :Chained('base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	if ($c->request->method eq 'POST') {
		$self->handle_post(@_);
	}

	unless ($c->user_exists) {
		$c->stash(
			template => 'login.html'
		);
	}
	else {
		if ($c->check_any_user_role(qw/administrator manager/)) {
			$c->response->redirect('/admin');
		}
		elsif ($c->check_user_roles('tenant')) {
			$c->response->redirect('/tenant');
		}
		else {
			$c->response->redirect('/');
		}
	}
}

sub handle_post :Private {
	use Regexp::Common qw/Email::Address/;
	use Email::Address;

	my $self = shift;
	my ($c, @args) = @_;

	my $return_msg = "Login...";

	# minimal validation
	return "$return_msg failed." unless (
		defined $c->request->params->{login} &&
		defined $c->request->params->{password} &&
		length($c->request->params->{login}) >= 4 &&
		length($c->request->params->{password}) >= 4
	);

	# user may login using either their email or login name
	my $auth_key;
	if ($c->request->params->{login} =~ /$RE{Email}{Address}/) {
		$auth_key = 'email';
	}
	else {
		$auth_key = 'login';
	}

	# minimal authentication parameters
	my $is_authenticated = $c->authenticate({
		$auth_key => $c->request->params->{login}, # username =~ login or email
		password  => $c->request->params->{password}
	});

	if ($is_authenticated) {
		return "$return_msg success!"
	}
	else {
		return "$return_msg failed: bad login and/or password";
	}
}

1;
