# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Admin::Building::Details;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base :Chained('/admin/building/id') :PathPart('details') :CaptureArgs(0) {}
sub details :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST') {
		my $params = $c->request->params;
		my $update = {};

		do {
			if ($params->{$_}) {
				$update->{$_} = 1;
			}
			else {
				$update->{$_} = 0;
			}
		} for qw/school_area bus_area campus_area washer_dryer basement garage yard/;
		do {
			$update->{$_} = $params->{$_} if $params->{$_};
		} for qw/full_address latitude_longitude description/;

		if ($params->{full_address}) {
			$update->{name} = $params->{full_address};
			$update->{name} =~ s/,.*$/./;
			$update->{name} =~ s/ ([NSEW]) / $1. /;

			$update->{city} = $params->{full_address};
			$update->{city} =~ s/^[^,]*, ([^,]+), .*/$1/;
			$update->{city} = undef if $update->{city} ne 'Champaign' and $update->{city} ne 'Urbana';
		}

		$c->stash->{building}->update($update);
		$c->response->redirect('/admin');
	}

	$c->stash->{template} = 'admin/building/details.html';
}

1;
