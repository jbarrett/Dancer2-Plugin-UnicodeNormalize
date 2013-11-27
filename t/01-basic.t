use strict;
use warnings;

use utf8;
use charnames ':full';

use Test::More tests => 3;
use t::lib::TestApp;
use Dancer2::Test apps => ['t::lib::TestApp'];

t::lib::TestApp::config->{'charset'} = 'UTF-8';

my $string1 = "\N{LATIN CAPITAL LETTER A}\N{COMBINING ACUTE ACCENT}";
my $string2 = "\N{LATIN CAPITAL LETTER A WITH ACUTE}";

isnt ($string1, $string2, "Initial conditions: strings are composed differently, are not equal");

response_content_is [ GET => "/cmp/$string1/$string2" ], "eq", "GET: Equality for differently composed strings";

my $response = dancer_response POST => '/cmp', { params => { string1 => $string1, string2 => $string2 } };
is ($response->content, 'eq', "POST: Equality for differently composed strings");

