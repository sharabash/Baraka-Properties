package Baraka::Controller::Building;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(1) {
	my $self = shift;
	my ($c, @args) = @_;
	my $building_name = pop @args;

	$c->stash->{building} = $c->model('DB::Building')->find({ name => $building_name });

	$c->stash(
		template => 'building.html'
	);
}

1;
