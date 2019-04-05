package App::Spoor::TransmissionFormatter;

use v5.10;
use strict;
use warnings;

=head1 NAME

App::Spoor::TransmissionFormatter

=head1 SYNOPSIS

Transforms the format of an item so that it is suitable for submission to the Spoor API.

=head1 SUBROUTINES

=head2 format

Takes a hash representation of a hash as input and returns an entry converted into a format suitable for submission to
the Spoor API.

  use Sys::Hostname;
  my $host = hostname;

  my %login_entry = (
    type => 'login',
    event => 'login',
    log_time => DateTime->new(
      year => 2018,
      month => 9,
      day => 19,
      hour => 16,
      minute => 2,
      second => 36,
      time_zone => '+0000'
    )->epoch(),
    scope => 'webmaild',
    ip => '10.10.10.10',
    credential => 'rorymckinley@blah.capefox.co',
    possessor => 'blahuser',
    status => 'success',
    context => 'foobar'
  );

  $formatted_entry = App::Spoor::TransmissionFormatter.format(\%login_entry, $host);

=cut

sub format {
  my $entry = shift;
  my $host = shift;

  if($entry->{event} eq 'login') {
    {
      type => $entry->{event},
      time => $entry->{log_time},
      ip => $entry->{ip},
      mailbox_address => $entry->{credential},
      context => $entry->{context},
      host => $host
    }
  } elsif($entry->{event} eq 'forward_added_partial_ip') {
    {
      type => $entry->{event},
      time => $entry->{log_time},
      ip => $entry->{ip},
      mailbox_address => $entry->{credential},
      context => $entry->{context},
      host => $host
    }
  } elsif($entry->{event} eq 'forward_added_partial_recipient') {
    {
      type => $entry->{event},
      time => $entry->{log_time},
      mailbox_address => $entry->{email},
      forward_recipient => $entry->{forward_to},
      context => $entry->{context},
      host => $host
    }
  } elsif($entry->{event} eq 'forward_removed') {
    {
      type => $entry->{event},
      time => $entry->{log_time},
      mailbox_address => $entry->{credential},
      forward_recipient => $entry->{forward_recipient},
      ip => $entry->{ip},
      context => $entry->{context},
      host => $host
    }
  }
}

=head1 AUTHOR

Rory McKinley, C<< <rorymckinley at capefox.co> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-. at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=.>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Spoor::TransmissionFormatter


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

1; # End of App::Spoor::TransmissionFormatter
