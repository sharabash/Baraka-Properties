# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Prospective;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base :Chained('/') :PathPart('prospective') :CaptureArgs(0) {
	my $self = shift;
	my ($c, @args) = @_;
}

sub _index :Chained('base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;
	$c->stash(template => 'prospective.html');
}

1;
