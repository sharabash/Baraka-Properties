package Baraka::Controller::Contact;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use Mail::SendEasy;

sub base :Chained('/') :PathPart('contact') :CaptureArgs(0) {
	my $self = shift;
	my ($c, @args) = @_;
}

sub contact :Chained('base') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	$c->stash(
		template => 'contact.html'
	);
}

sub _unit_id :Chained('base') :PathPart('') :CaptureArgs(1) {
	my $self = shift;
	my ($c, $unit_id) = @_;
	my $unit = $c->model('DB::Unit')->find({ unit_id => $unit_id }, {
		select => ['me.type', 'me.name', 'building.name'],
		as => ['type', 'name', 'building_name'],
		join => ['building']
	});

	$c->stash->{subject} = $unit->get_column('building_name') .', '. $unit->type .' '. ($unit->name || '');
}

sub unit_id :Chained('_unit_id') :PathPart('') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	$c->stash(
		template => 'contact.html'
	);
}

sub submit :Chained('base') :PathPart('submit') :Args(0) {
	my $self = shift;
	my ($c, @args) = @_;

	return if $c->request->method ne 'POST';

	my $params = $c->request->params;

	my $first = $params->{first};
	my $last = $params->{last};
	my $email = $params->{email};
	my $phone = $params->{phone};
	my $subject = $params->{subject};
	my $message = $params->{message};

	if ($first && $last && $email && $message) {
		my $mail = new Mail::SendEasy(
			smtp => 'host.domain.tld',
			port => 587,
			user => 'username',
			pass => 'passwd'
		);

		$message = <<MESSAGE
		<table border="0">
			<tbody>
				<tr><td colspan="3" style="padding: 2px;"></td></tr>
				<tr>
					<td><b>First name</b></td>
					<td style="padding: 0 16px;"></td>
					<td><b>Last name</b></td>
				</tr>
				<tr>
					<td>$first</td>
					<td style="padding: 0 16px;"></td>
					<td>$last</td>
				</tr>
				<tr><td colspan="3" style="padding: 2px;"></td></tr>
				<tr>
					<td><b>Email address</b></td>
					<td style="padding: 0 16px;"></td>
					<td><b>Phone number</b></td>
				</tr>
				<tr>
					<td>$email</td>
					<td style="padding: 0 16px;"></td>
					<td>$phone</td>
				</tr>
				<tr><td colspan="3" style="padding: 8px;"></td></tr>
				<tr><td colspan="3"><b>Subject</b></td></tr>
				<tr><td colspan="3">$subject</td></tr>
				<tr><td colspan="3" style="padding: 2px;"></td></tr>
				<tr><td colspan="3"><b>Message</b></td></tr>
				<tr><td colspan="3">$message</td></tr>
			</tbody>
		</table>
MESSAGE
		;

		my $status = $mail->send(
			from => $email,
			from_title => "$first $last",
			to => 'info@baraka-apts.com',
			subject => 'baraka-apts.com: '. ($subject? $subject : '(no subject)'),
			html => $message
		);

		if (!$status) {
			$c->stash->{response} = ['There was a problem on our end, and we could not send your message. Please <a href="mailto:baraka.prop@gmail.com">e-mail us</a> instead for the time being.'];
		}
		else {
			$c->stash->{response} = ['Your message was successfully sent. We should reply soon!'];
			$c->stash->{success} = 1;
		}
	}
	else {
		my $response = ['There were problems with your submission:'];
		$c->stash->{response} = $response;

		push @{$response}, "Provide your full name." if !$first || !$last;
		push @{$response}, "Provide your email address." if !$email;
		push @{$response}, "Provide a message." if !$message;

		$c->stash->{subject} = $subject;
		$c->stash->{message} = $message;
	}

	$c->session->{first}   = $first;
	$c->session->{last}    = $last;
	$c->session->{email}   = $email;
	$c->session->{phone}   = $phone;

	$c->detach('Baraka::Controller::Contact', 'contact');
}

1;
