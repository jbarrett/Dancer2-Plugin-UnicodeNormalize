package t::lib::TestApp;

use Dancer2;
use Dancer2::Plugin::UnicodeNormalize;

get '/:string1/:string2' => sub {
    return 'missing parameter!' unless ( param('string1') && param('string2') );
    return ( ( param('string1') eq param('string2') ) ? 'eq' : 'ne' );
};

post '/' => sub {
    return 'missing parameter!' unless ( param('string1') && param('string2') );
    return ( ( param('string1') eq param('string2') ) ? 'eq' : 'ne' );
};

