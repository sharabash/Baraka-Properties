package Baraka::Controller::Submit;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use Mail::SendEasy;

sub index :Path :Args(0) {
	my ($self, $c) = @_;
	my $pdf = $c->request->body;
	if ($pdf) {
		`cp $pdf /work/baraka-apts.com/tmp/application.pdf`; # TODO refactor this crude hack?
		my $mail = new Mail::SendEasy(
			smtp => 'host.domain.tld',
			port => 587,
			user => 'username',
			pass => 'passwd'
		);
		my $status = $mail->send(
			from => 'info@baraka-apts.com',
			from_title => "baraka-apts.com",
			to => 'info@baraka-apts.com',
			subject => 'baraka-apts.com: Application Submission',
			msg => 'Attached is an application from a prospective tenant, in PDF format.',
			anex => '/work/baraka-apts.com/tmp/application.pdf'
		);
		if (!$status) {
			$c->response->body('There was a problem handling your submission on our end.<br/>Please save the application and mail it to info@baraka-apts.com instead.');
		}
		else {
			$c->response->body('Your application has been successfully received.<br/>We will review it and contact you shortly.<br/>Please email info@baraka-apts.com if you have any questions.');
		}
	}
	else {
		$c->response->body('Hmmm...');
	}
}

1;
