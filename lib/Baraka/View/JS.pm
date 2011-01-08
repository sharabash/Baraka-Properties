# vim: ts=2 sw=2 noexpandtab
package Baraka::View::JS;

use strict;
use warnings;
use base 'Catalyst::View::JSON';

__PACKAGE__->config({
        allow_callback => 1,
        callback_param => 'qr/^js_cb_/',
        expose_stash => qr/^js_/
});

1;
