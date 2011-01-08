package Baraka::Schema::Result::PersonRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("person_role");
__PACKAGE__->add_columns(
  "person_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "role_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
);
__PACKAGE__->set_primary_key("person_id", "role_id");
__PACKAGE__->add_unique_constraint("person_role_pkey", ["person_id", "role_id"]);
__PACKAGE__->belongs_to(
  "person",
  "Baraka::Schema::Result::Person",
  { person_id => "person_id" },
);
__PACKAGE__->belongs_to(
  "role",
  "Baraka::Schema::Result::Role",
  { role_id => "role_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4qra2cMeD29gXzYlKXNbFA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
