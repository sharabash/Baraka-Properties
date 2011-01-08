package Baraka::Schema::Result::Role;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("role");
__PACKAGE__->add_columns(
  "role_id",
  {
    data_type => "integer",
    default_value => "nextval('role_role_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "role",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("role_id");
__PACKAGE__->add_unique_constraint("role_pkey", ["role_id"]);
__PACKAGE__->add_unique_constraint("role_role_key", ["role"]);
__PACKAGE__->has_many("map_person_role" => "Baraka::Schema::Result::PersonRole", "role_id");
__PACKAGE__->many_to_many("people" => "map_person_role", "person");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aXDzTm/hbiUlvztw9YImyg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
