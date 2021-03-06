package Baraka::Schema::Result::BuildingPicture;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("building_picture");
__PACKAGE__->add_columns(
  "building_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "picture_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
);
__PACKAGE__->set_primary_key("building_id", "picture_id");
__PACKAGE__->add_unique_constraint("building_picture_pkey", ["building_id", "picture_id"]);
__PACKAGE__->belongs_to(
  "building_id",
  "Baraka::Schema::Result::Building",
  { building_id => "building_id" },
);
__PACKAGE__->belongs_to(
  "picture",
  "Baraka::Schema::Result::Picture",
  { picture_id => "picture_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dj967qnKShGL4BK32qPKuQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
