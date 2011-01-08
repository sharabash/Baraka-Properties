package Baraka::Schema::Result::Session;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("session");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "session_data",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "created",
  {
    data_type => "timestamp without time zone",
    default_value => undef,
    is_nullable => 1,
    size => 8,
  },
  "expires",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("session_pkey", ["id"]);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yxdmSIyMUF19+BCDyb/AgA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
