package App::Spoor::Config;

use v5.10;
use strict;
use warnings;

use YAML::Tiny qw(Load);
use Path::Tiny qw(path);

=head1 NAME

App::Spoor::Config

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Allows access to the spoor config file located at /etc/spoor/spoor.yml which currently has the following format;

  ---
  application:
    ignored_entries_path: //var/lib/spoor/ignored
    parsed_entries_path: //var/lib/spoor/parsed
    transmitted_entries_path: //var/lib/spoor/transmitted
  followers:
    access:
      debug: 1
      maxinterval: 10
      name: /usr/local/cpanel/logs/access_log
      transformer: bin/login_log_transformer.pl
    error:
      debug: 1
      maxinterval: 10
      name: /usr/local/cpanel/logs/error_log
      transformer: bin/login_log_transformer.pl
    login:
      debug: 1
      maxinterval: 10
      name: /usr/local/cpanel/logs/login_log
      transformer: bin/login_log_transformer.pl
  transmission:
    credentials:
      api_identifier: api_identifier_goes_here
      api_secret: api_secret_goes_here
    endpoints:
      report: /api/reports
    host: https://spoor.capefox.co

=head1 SUBROUTINES/METHODS

=head2 get_follower_config

Gets the config related to a specific type of follower (access, error, login).

  $reference_to_access_config_hash = App::Spoor::Config::get_follower_config('access');

  # Optionally, you can pass in an alternative to the root path '/' which is used when building the path
  # to the config file. In the code snipper below, the method will look for the config file in /tmp/etc/spoor
  # rather than /etc/spoor. This is primarily used to support testing.

  $reference_to_access_config_hash = App::Spoor::Config::get_follower_config('access', '/tmp');

=cut

sub get_follower_config {
  my $follower_type = shift @_;
  my $root_path = shift @_ // '/';
  my $config_file_path = "$root_path/etc/spoor/spoor.yml"; 
  my $file_contents = path($config_file_path)->slurp_utf8;

  Load($file_contents)->{'followers'}{$follower_type};
}

=head2 get_application_config

Returns application config. This is *not* actually read from the config file but it is, for now, hard coded data. 
Should the contents of the application config ever become more dynamic this will change.

  $reference_to_application_config_hash = App::Spoor::Config::get_application_config();

  # Optionally, you can pass in an alternative to the root path '/' which is used when building the path
  # to the config file. In the code snipper below, the method will look for the config file in /tmp/etc/spoor
  # rather than /etc/spoor. This is primarily used to support testing.

  $reference_to_application_config_hash = App::Spoor::Config::get_application_config('/tmp');

=cut

sub get_application_config {
  # YAGNI - Hard code application config - cleaner and more reliable than trying to sanitise the paths
  {   
    parsed_entries_path => '/var/lib/spoor/parsed',
    transmitted_entries_path => '/var/lib/spoor/transmitted',
    transmission_failed_entries_path => '/var/lib/spoor/transmission_failed',
  };
}

=head2 get_transmission_config

Returns the config from the `transmission` section of the config file.

  $reference_to_transmission_config_hash = App::Spoor::Config::get_transmission_config('access');

  # Optionally, you can pass in an alternative to the root path '/' which is used when building the path
  # to the config file. In the code snipper below, the method will look for the config file in /tmp/etc/spoor
  # rather than /etc/spoor. This is primarily used to support testing.

  $reference_to_transmission_config_hash = App::Spoor::Config::get_transmission_config('/tmp');

=cut

sub get_transmission_config {
  my $root_path = shift @_ // '/';
  my $config_file_path = "$root_path/etc/spoor/spoor.yml"; 
  my $file_contents = path($config_file_path)->slurp_utf8;

  Load($file_contents)->{'transmission'};
}

=head1 AUTHOR

Rory McKinley, C<< <rorymckinley at capefox.co> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-. at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=.>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Spoor::Config


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

1; # End of App::Spoor::Config
