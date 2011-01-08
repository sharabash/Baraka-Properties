# بسم الله الرحمن الرحيم
# vim: ts=2 sw=2 noexpandtab
package Baraka;

use strict;
use warnings;

our $VERSION = '0.01';

use Baraka;
use Catalyst::Runtime '5.80007';
use parent qw/Catalyst/;
use Catalyst qw/-Debug
	ConfigLoader
	Static::Simple

	StackTrace

	Authentication
	Authorization::Roles

	Session
	Session::Store::DBIC
	Session::State::Cookie
/;

__PACKAGE__->config();

__PACKAGE__->setup();


1;
