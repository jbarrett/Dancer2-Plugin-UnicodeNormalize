package t::lib::TestApp;

use Dancer2;
use Dancer2::Plugin::UnicodeNormalize;

set charset => 'UTF-8';
set apphandler => 'PSGI';
set log => 'error';

get '/cmp/:string1/:string2' => sub {
    return 'missing parameter!' unless ( param('string1') && param('string2') );
    return ( ( param('string1') eq param('string2') ) ? 'eq' : 'ne' );
};

post '/cmp' => sub {
    return 'missing parameter!' unless ( param('string1') && param('string2') );
    return ( ( param('string1') eq param('string2') ) ? 'eq' : 'ne' );
};

post '/upload' => sub {
    my ($file1, $file2) = (upload('file1'), upload('file2'));
    return ( ( $file1->content eq $file2->content ) ? 'eq' : 'ne' );
};

get '/form/:string' => sub {
    return param('string');
};

get '/optional/:string?' => sub {
    return 'success';
};

1;

