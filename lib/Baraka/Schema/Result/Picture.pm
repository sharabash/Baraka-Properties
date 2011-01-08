package Baraka::Schema::Result::Picture;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("picture");
__PACKAGE__->add_columns(
  "picture_id",
  {
    data_type => "integer",
    default_value => "nextval('picture_picture_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "label",
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
  "type",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "category",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "picture", { data_type => "bytea" },
  "mime", { data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "filename",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "filesize",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "width",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "height",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("picture_id");
__PACKAGE__->add_unique_constraint("picture_pkey", ["picture_id"]);
__PACKAGE__->add_unique_constraint("picture_filename_key", ["filename"]);
__PACKAGE__->has_many(
  "building_pictures",
  "Baraka::Schema::Result::BuildingPicture",
  { "foreign.picture_id" => "self.picture_id" },
);
__PACKAGE__->has_many(
  "unit_pictures",
  "Baraka::Schema::Result::UnitPicture",
  { "foreign.picture_id" => "self.picture_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8yfvn/e/hkzr1jor8+FtGA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
