use strict;
use warnings;

use utf8;

use Test::More tests => 3;
use t::lib::TestApp;
use Dancer2::Test apps => ['t::lib::TestApp'];

my $string1 = "\N{LATIN CAPITAL LETTER A}\N{COMBINING ACUTE ACCENT}";
my $string2 = "\N{LATIN CAPITAL LETTER A WITH ACUTE}";

isnt ($string1, $string2, "Initial conditions: strings are composed differently, are not equal");

response_content_is [ GET => "/$string1/$string2" ], "eq", "GET: Equality for differently composed strings";

my $response = dancer_response POST => '/', { params => { string1 => $string1, string2 => $string2 } };
is ($response->content, 'eq', "POST: Equality for differently composed strings");

