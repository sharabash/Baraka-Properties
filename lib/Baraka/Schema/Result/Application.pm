package Baraka::Schema::Result::Application;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components('InflateColumn::DateTime', 'Core');

__PACKAGE__->table('application');

__PACKAGE__->add_columns(
	'application_id', {
		data_type => 'integer',
		default_value => 'nextval("application_application_id_seq"::regclass)',
		is_nullable => 0,
		size => 4
	},
	'unit_address', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'application_date', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'commencing_date', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'ending_date', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'occupancy_date', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'charge_rent', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'charge_deposit', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'charge_other', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_birth_date', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_ss_num', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_phone', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_email', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_drivers_license_num', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'vehicle_make', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'vehicle_plate_num', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_marital_status', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_ss_num', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'num_occupants', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'occupant_names', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_address', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_address_city', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_address_state', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_address_zip_code', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_landlord_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_landlord_phone', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_landlord_rent', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_landlord_duration', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_position', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_pay', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_pay_period', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_address', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_phone', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'applicant_employer_duration', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_employer_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_employer_position', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_employer_duration', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_employer_address', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'spouse_employer_phone', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'bank_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'bank_account_num', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_relationship', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_phone', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_address', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_city', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_state', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'contact_zip_code', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'evicted', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'evicted_when', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'evicted_why', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_website', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_sign', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_referral', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_referral_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_google_adwords', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_craigslist', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_other', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'found_out_other_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'signature_name', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'signature_date', { data_type => 'text', default_value => undef, is_nullable => 1, size => undef },
	'created', { data_type => 'timestamp without time zone', default_value => undef, is_nullable => 1, size => 8 }
);

__PACKAGE__->set_primary_key('application_id');

__PACKAGE__->add_unique_constraint('application_pkey', ['application_id']);

#  Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-06-04 08:18:12
#  DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pf7FsH3HxbG1smstGwK15A
#  You can replace this text with custom content, and it will be preserved on regeneration1;

# vim: ts=2 sw=2 noexpandtab

