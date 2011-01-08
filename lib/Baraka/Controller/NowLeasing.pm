package Baraka::Controller::NowLeasing;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use DateTime;

sub index :Path :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	my $dt = DateTime->now;

	$c->stash->{todays_date}  = $dt->strftime("%A %B %e, %Y");
=cut
	$c->stash->{todays_date} =~ s/ 1,/ 1st,/;
	$c->stash->{todays_date} =~ s/ 2,/ 2nd,/;
	$c->stash->{todays_date} =~ s/ 3,/ 3rd,/;
	$c->stash->{todays_date} =~ s/ ([\d]+),/ $1th,/;
=cut
	$c->stash->{next_year}  = ($dt->month < 9)? $dt->year : $dt->year + 1;

	my $units = $c->model('DB::Unit')->search([
		leased_now => 0,
		leased_fall => 0
	],{
		'+columns' => {
			building_name => 'building.name',
			cache => 1
		},
		join => ['building'],
		order_by => 'building.name asc, me.rent desc, me.name asc'
		#{
		#	'-asc' => [qw/building.name me.rent me.name/]
		#}
	});

	$c->stash->{max_bedrooms} = $c->model('DB::Unit')->search(undef, {
		select => [{ max => 'bedrooms' }],
		as => ['max_bedrooms'],
		cache => 1
	})->first->get_column('max_bedrooms');

	$c->stash->{max_bathrooms} = $c->model('DB::Unit')->search(undef, {
		select => [{ max => 'bathrooms' }],
		as => ['max_bathrooms'],
		cache => 1
	})->first->get_column('max_bathrooms');

	$c->stash->{buildings} = {};

	while (my $unit = $units->next) {
		my $name = $unit->get_column('building_name');

		$c->stash->{buildings}->{$name} = [] unless $c->stash->{buildings}->{$name};

		push @{ $c->stash->{buildings}->{$name} }, $unit;
	}

	$c->stash(
		template => 'nowleasing.html'
	);
}

1;
