package Baraka::Schema::Result::Person;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components('InflateColumn::DateTime', 'Core');

__PACKAGE__->table('person');

__PACKAGE__->add_columns(
	'person_id', {
		data_type => 'integer',
		default_value => 'nextval("person_person_id_seq"::regclass)',
		is_nullable => 0,
		size => 4
	},

	'name',     { data_type => 'text', default_value => undef, is_nullable => 0, size => undef },

	'login',    { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'password', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },

	'email',    { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'phone',    { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },

	'token',    { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'active',   { data_type => 'boolean', default_value => 0 },

	'created',  { data_type => 'timestamp without time zone', default_value => undef, is_nullable => 1, size => 8 },
	'updated',  { data_type => 'timestamp without time zone', default_value => undef, is_nullable => 1, size => 8 }
);

__PACKAGE__->set_primary_key('person_id');

__PACKAGE__->add_unique_constraint('person_email_key', ['email']);
__PACKAGE__->add_unique_constraint('person_login_key', ['login']);
__PACKAGE__->add_unique_constraint('person_pkey', ['person_id']);

__PACKAGE__->has_many('map_person_role' => 'Baraka::Schema::Result::PersonRole', 'person_id');

__PACKAGE__->many_to_many('roles' => 'map_person_role', 'role');

#  Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
#  DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7NTfiThKmOrDwIqW6F9VDg
#  You can replace this text with custom content, and it will be preserved on regeneration1;

# vim: ts=2 sw=2 noexpandtab
