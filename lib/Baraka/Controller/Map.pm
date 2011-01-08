package Baraka::Controller::Map;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(1) {
	my ($self, $c, $building_id) = @_;

	my $building = $c->model('DB::Building')->find({ building_id => $building_id });
	$c->stash->{title} = $building->name;
	my @coordinates = split /,/, $building->latitude_longitude;
	$c->stash->{coordinates} = \@coordinates;

	$c->stash(
		template => 'map.html'
	);
}


1;
