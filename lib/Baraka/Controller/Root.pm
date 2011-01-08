# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub auto :Private {
	my ($self, $c) = @_;
	use Date::Format;
	$c->stash->{next_year} = time2str("%y",time);
}

sub index :Path :Args(0) {
	my ($self, $c) = @_;
	$c->detach('Baraka::Controller::NowLeasing', 'index');
}

sub default :Path {
	my ($self, $c) = @_;
	$c->response->body( 'Page not found' );
	$c->response->status(404);
}

sub begin :Private {
	my $self = shift;
	my ($c, @args) = @_;
}

sub end :ActionClass('RenderView') {
	my $self = shift;
	my ($c, @args) = @_;

	$c->forward('error') if $c->stash->{error};
}

sub error :Path('error') {
	my ($self, $c, @args) = @_;
	$c->stash(
		template => 'error.html'
	);
}

1;
