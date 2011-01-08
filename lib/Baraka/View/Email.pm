# vim: ts=2 sw=2 noexpandtab
package Baraka::View::Email;

use strict;
use base 'Catalyst::View::Email';

__PACKAGE__->config({
    stash_key => 'email',
	default => {
		content_type => 'text/plain',
		charset => 'utf-8'
	},
	sender => {
		mailer => 'SMTP',
		mailer_args => {
			Host     => 'host.domain.tld',
			username => 'username',
			password => 'passwd',
		}
	}
});

1;
