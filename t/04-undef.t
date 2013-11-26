use strict;
use warnings;

use Test::More tests => 1;
use t::lib::TestApp;
use Dancer2::Test apps => ['t::lib::TestApp'];

response_content_is [ GET => "/optional/" ], "success", "Do not bail out on missing/undef optional params";


