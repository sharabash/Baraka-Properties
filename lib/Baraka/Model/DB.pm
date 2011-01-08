package Baraka::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

our @connect_info = ('dbi:Pg:dbname=baraka;user=baraka', 'baraka', 'baraka',
	{ pg_bool_tf => 0, pg_enable_utf8 => 1, AutoCommit => 1, RaiseError => 1 });

__PACKAGE__->config(
        schema_class => 'Baraka::Schema',
        connect_info => \@connect_info
);

=head1 NAME

Baraka::Model::DB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<Baraka>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Baraka::Schema>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
