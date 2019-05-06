use strict;
use warnings;
use utf8;

use Test::More;
use Test::LWP::UserAgent;
use MIME::Base64 qw(encode_base64);
use JSON;

my %config = (
  credentials => {
    api_identifier => 'user123',
    api_secret => 'secret',
  },
  host => 'http://localhost:3000',
  endpoints => {
    report => '/api/reports',
  },
  reporter => 'spoor.test.capefox.co'
);

BEGIN {
  use_ok('App::Spoor::ApiClient') || print('Could not load App::Spoor::ApiClient');
}

ok(defined(&App::Spoor::ApiClient::most_recent_reports), 'App::Spoor::ApiClient::most_recent_reports is defined');

my $ua = Test::LWP::UserAgent->new;
my $host = 'host1';
my @reports_data = (
  {
    id => '456-GHI',
    event_time => 1555588110,
    host => 'spoor2.test.com',
    type => 'forward_removed',
    mailbox_address => 'anothervictim@test.com'
  },
  {
    id => '123-ABC',
    event_time => 1555513150,
    host => 'spoor.test.com',
    type => 'login',
    mailbox_address => 'victim@test.com'
  },
);
my $api_response = to_json({reports => \@reports_data});
$ua->map_response(qr{reports}, HTTP::Response->new('200', 'OK', ['Content-Type' => 'application/json'], $api_response));

my $result = App::Spoor::ApiClient::most_recent_reports($host, $ua, \%config);

my $last_request = $ua->last_http_request_sent;

is(($last_request->method()), 'GET', 'Makes a GET request');
is(($last_request->uri()), "http://localhost:3000/api/reports?reports%5Bhost%5D=$host", 'Correctly builds the URI');
is($last_request->header('HTTP-Accept'), 'application/json', 'JSON content type');
is($last_request->header('Authorization'), 'Basic ' . encode_base64('user123:secret'), 'Sets basic auth credentials');

is_deeply($result, \@reports_data, 'Returns a reference to the reports from the API');

done_testing();
