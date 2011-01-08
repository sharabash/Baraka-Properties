package Baraka::View::HTML;

use strict;
use warnings;
use base 'Catalyst::View::Mason';

__PACKAGE__->config({
	use_match => 0,
	autohandler_name => 'auto.html',
	allow_globals => ['$stash','$session','$flash','$params']
});

1;
