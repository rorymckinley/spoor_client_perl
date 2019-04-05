package App::Spoor::EntryTransmitter;

use v5.10;
use strict;
use warnings;
use JSON;

use MIME::Base64 qw(encode_base64);
=head1 NAME

App::Spoor::EntryTransmitter

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Makes a call to the Spoor API.

=head1 SUBROUTINES/METHODS

=head2 transmit

Transmits a report to the Spoor API. Returns a 'truthy' response if the API responds with HTTP '202', and a falsey response if the API responds with anything other than '202'.

  my %data = (
    ...
  );
  my $user_agent = LWP::UserAgent->new;

  my $transmission_config = App::Spoor::Config::get_transmission_config();
  $transmission_config->{'reporter'} = 'foo.baz.com';

  App::Spoor::EntryTransmitter::transmit(\%data, $user_agent, $transmission_config);

=cut

sub transmit {
  my $data = shift;
  my $ua = shift;
  my $config = shift;

  my $uri = $config->{host} . $config->{endpoints}{report};

  my $credentials = 'Basic ' . encode_base64(
    $config->{credentials}{api_identifier} . ':' . $config->{credentials}{api_secret}
  );

  my $content = to_json({
    report => {
      entries => [
        $data
      ],
      metadata => {
        reporter => $config->{reporter}
      }
    },
  });

  my $result = $ua->post(
    $uri,
    'Content-Type' => 'application/json',
    'Authorization' => $credentials,
    'Content' => $content
  );

  $result->code() eq '202';
}

=head1 AUTHOR

Rory McKinley, C<< <rorymckinley at capefox.co> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-. at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=.>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Spoor::EntryTransmitter


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=.>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/.>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/.>

=item * Search CPAN

L<https://metacpan.org/release/.>

=back

=head1 LICENSE AND COPYRIGHT
Copyright 2019 Rory McKinley.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of App::Spoor::EntryTransmitter
