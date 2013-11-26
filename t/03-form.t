use strict;
use warnings;

use utf8;

use Test::More tests => 4;
use t::lib::TestApp;
use Dancer2::Test apps => ['t::lib::TestApp'];
use Unicode::Normalize qw/NFD NFC NFKD NFKC/;
use Encode;

t::lib::TestApp::config->{'charset'} = 'UTF-8';

my $string = "\N{OHM SIGN}\N{GREEK CAPITAL LETTER OMEGA}\N{LATIN CAPITAL LETTER A}\N{COMBINING ACUTE ACCENT}\N{LATIN CAPITAL LETTER A WITH ACUTE}\N{LATIN SMALL LETTER LONG S WITH DOT ABOVE}\N{COMBINING DOT BELOW}";

t::lib::TestApp::config->{'plugins'}->{'UnicodeNormalize'}->{'form'} = 'NFD';
my $response = dancer_response GET => "/form/$string";
is (decode('UTF-8', $response->content), NFD($string), "NFD form returned");

t::lib::TestApp::config->{'plugins'}->{'UnicodeNormalize'}->{'form'} = 'NFC';
$response = dancer_response GET => "/form/$string";
is (decode('UTF-8', $response->content), NFC($string), "NFC form returned");

t::lib::TestApp::config->{'plugins'}->{'UnicodeNormalize'}->{'form'} = 'NFKD';
$response = dancer_response GET => "/form/$string";
is (decode('UTF-8', $response->content), NFKD($string), "NFKD form returned");

t::lib::TestApp::config->{'plugins'}->{'UnicodeNormalize'}->{'form'} = 'NFKC';
$response = dancer_response GET => "/form/$string";
is (decode('UTF-8', $response->content), NFKC($string), "NFKC form returned");

