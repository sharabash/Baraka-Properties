# vim: ts=2 sw=2 noexpandtab
package Baraka::Controller::Admin::Building::Units;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base :Chained('/admin/building/id') :PathPart('units') :CaptureArgs(0) {}

sub units :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;

	$c->stash(
		template => 'admin/building/units.html',
		units => scalar($c->stash->{building}->units->search(undef, {
			order_by => 'name',
			cache => 1
		}))
	);
}

sub create :Chained('base') :PathPart('create') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST') {
		my $name = $c->request->params->{name};
		my $type = $c->request->params->{type};

		if ($name && $type) {
			my $unit = $c->model('DB::Unit')->find_or_create({
				building_id => $c->stash->{building}->building_id,
				name => $name,
				type => $type
			}) or die $!;
		}
	}

	$c->response->redirect('/admin/building/'. $c->stash->{building}->building_id .'/units');
}

sub id :Chained('/admin/building/id') :PathPart('units') :CaptureArgs(1) {
	my ($self, $c, $unit_id) = @_;

	if ($unit_id !~ /^\d+$/) {
		$c->detach('/');
		return;
	}
	else {
		$c->stash->{unit} = $c->model('DB::Unit')->find({ unit_id => $unit_id });
	}
}

sub update :Chained('id') :PathPart('update') :Args(0) {
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
		} for qw/leased_now leased_fall furnished dishwasher garbage recycling sewer water electricity gas internet washer_dryer/;
		do {
			$update->{$_} = $params->{$_} if defined $params->{$_} and $params->{$_} ne '';
		} for qw/type name bedrooms bathrooms parking description/;

		if (defined $params->{rent}) {
			$update->{rent} = $params->{rent};
			$update->{rent} =~ s/[^\d.\$]//g;
			$update->{rent} = '$'. $update->{rent} if $update->{rent} !~ /\$/;
		}

		$c->stash->{unit}->update($update);
	}

	$c->response->redirect('/admin/building/'. $c->stash->{building}->building_id .'/units');
}

sub delete :Chained('id') :PathPart('delete') :Args(0) {
	my ($self, $c) = @_;

	if ($c->request->method eq 'POST' and $c->check_user_roles('administrator')) {
		$c->stash->{unit}->delete;
	}

	$c->response->redirect('/admin/building/'. $c->stash->{building}->building_id .'/units');
}

1;
