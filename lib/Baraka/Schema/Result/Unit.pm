package Baraka::Schema::Result::Unit;

use strict;
use warnings;

use base 'DBIx::Class';

use Time::JulianDay;
use DateTime::Format::Pg;

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("unit");
__PACKAGE__->add_columns(
  "building_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "unit_id",
  {
    data_type => "integer",
    default_value => "nextval('unit_unit_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "type",
  {
    data_type => "type",
    is_nullable => 1
  },
  "name",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "bedrooms",
  { data_type => "numeric(2,1)", is_nullable => 1 },
  "bathrooms",
  { data_type => "numeric(2,1)", is_nullable => 1 },
  "parking",
  { data_type => "parking", is_nullable => 1 },
  "furnished",
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
  "dishwasher",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "garbage",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "recycling",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "sewer",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "water",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "electricity",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "gas",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "internet",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "leased_now",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "leased_fall",
  {
    data_type => "boolean",
    is_nullable => 1,
    size => 1,
	},
  "rent",
  { data_type => "money", is_nullable => 1 },
	"description",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("unit_id");
__PACKAGE__->add_unique_constraint("unit_pkey", ["unit_id"]);
__PACKAGE__->has_many(
  "applications",
  "Baraka::Schema::Result::Application",
  { "foreign.unit_id" => "self.unit_id" },
);
__PACKAGE__->belongs_to(
  "building",
  "Baraka::Schema::Result::Building",
  { building_id => "building_id" },
);
__PACKAGE__->has_many(
  "pictures",
  "Baraka::Schema::Result::UnitPicture",
  { "foreign.unit_id" => "self.unit_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+soHgO5YkhCy3ob5fzPKHQ

sub available_now {
	my $self = shift;

	return !$self->leased_now;
}

sub available_fall {
	my $self = shift;

	return !$self->leased_fall;
}

sub rent_float {
	my $self = shift;
	
	my $rent = $self->rent;
	$rent =~ s/\$//g;
	return $rent;
}

1;
