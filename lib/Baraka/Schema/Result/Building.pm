package Baraka::Schema::Result::Building;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("building");
__PACKAGE__->add_columns(
  "building_id",
  {
    data_type => "integer",
    default_value => "nextval('building_building_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "name",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "garage",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "basement",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "yard",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "washer_dryer",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "city",
  {
    data_type => "city",
    is_nullable => 1
  },
  "campus_area",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "school_area",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "bus_area",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
  },
  "full_address",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "latitude_longitude",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "description",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("building_id");
__PACKAGE__->add_unique_constraint("building_pkey", ["building_id"]);
__PACKAGE__->add_unique_constraint("building_name_key", ["name"]);
__PACKAGE__->has_many(
  "building_pictures",
  "Baraka::Schema::Result::BuildingPicture",
  { "foreign.building_id" => "self.building_id" },
);
__PACKAGE__->many_to_many('pictures', 'building_pictures', 'picture');
__PACKAGE__->has_many(
  "units",
  "Baraka::Schema::Result::Unit",
  { "foreign.building_id" => "self.building_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gqAuUvZh3FKweE8aJ6tShw

sub in_urbana {
	my $self = shift;

	return ($self->city eq 'Urbana' )? 1 : 0;
}

sub in_champaign {
	my $self = shift;

	return ($self->city eq 'Champaign')? 1 : 0;
}

sub units_max_bedrooms {
	my $self = shift;

	return $self->search_related('units', undef, {
		select => [{ max => 'bedrooms' }],
		as => ['max_bedrooms'],
		cache => 1
	})->first->get_column('max_bedrooms');
}

sub units_max_bathrooms {
	my $self = shift;

	return $self->search_related('units', undef, {
		select => [{ max => 'bathrooms' }],
		as => ['max_bathrooms'],
		cache => 1
	})->first->get_column('max_bathrooms');
}

sub units_min_rent {
	my $self = shift;

	my $float = $self->search_related('units', undef, {
		select => [{ min => 'rent' }],
		as => ['min_rent'],
		cache => 1
	})->first->get_column('min_rent');
	$float =~ s/\$//;
	return $float;
}

sub units_max_rent {
	my $self = shift;

	my $float = $self->search_related('units', undef, {
		select => [{ max => 'rent' }],
		as => ['max_rent'],
		cache => 1
	})->first->get_column('max_rent');
	$float =~ s/\$//;
	return $float;
}

sub units_available_now {
	my $self = shift;

	return $self->search_related('units', { leased_now => 0 })->count? 1 : 0;
}

sub units_available_fall {
	my $self = shift;

	return $self->search_related('units', { leased_fall => 0 })->count? 1 : 0;
}

sub units_type_apartment {
	my $self = shift;

	return $self->search_related('units', { type => 'Apartment' })->count? 1 : 0;
}

sub units_type_house {
	my $self = shift;

	return $self->search_related('units', { type => 'House' })->count? 1 : 0;
}

sub units_type_trailer {
	my $self = shift;

	return $self->search_related('units', { type => 'Trailer' })->count? 1 : 0;
}

sub units_type_storage {
	my $self = shift;

	return $self->search_related('units', { type => 'Storage' })->count? 1 : 0;
}


sub units_with_water {
	my $self = shift;

	return $self->search_related('units', { water => 1 })->count? 1 : 0;
}

sub units_with_gas {
	my $self = shift;

	return $self->search_related('units', { gas => 1 })->count? 1 : 0;
}

sub units_with_electricity {
	my $self = shift;

	return $self->search_related('units', { electricity => 1 })->count? 1 : 0;
}

sub units_with_garbage {
	my $self = shift;

	return $self->search_related('units', { garbage => 1 })->count? 1 : 0;
}

sub units_with_recycling {
	my $self = shift;

	return $self->search_related('units', { recycling => 1 })->count? 1 : 0;
}

sub units_with_internet {
	my $self = shift;

	return $self->search_related('units', { internet => 1 })->count? 1 : 0;
}

sub units_with_parking {
	my $self = shift;

	return $self->search_related('units', { parking => 'included' })->count? 1 : 0;
}

sub units_with_furnished {
	my $self = shift;

	return $self->search_related('units', { furnished => 1 })->count? 1 : 0;
}

sub units_with_dishwasher {
	my $self = shift;

	return $self->search_related('units', { dishwasher => 1 })->count? 1 : 0;
}

sub units_with_washer_dryer {
	my $self = shift;

	return ($self->search_related('units', { washer_dryer => 1 })->count or
	        $self->search_related('units')->count eq 1 and $self->washer_dryer)? 1 : 0;
}

1;
