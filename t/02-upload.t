use strict;
use warnings;

use utf8;
use autodie;

use Test::More tests => 2;
use t::lib::TestApp;
use Dancer2::Test apps => ['t::lib::TestApp'];
use Encode;
use FindBin;
use Digest::MD5 qw/md5/;

t::lib::TestApp::config->{'charset'} = 'UTF-8';

my $files = "$FindBin::Bin/files";

open my $f1, '<:utf8', "${files}/1.txt";
open my $f2, '<:utf8', "${files}/2.txt";
chomp(my $string1 = <$f1>);
chomp(my $string2 = <$f2>);
close ($f1);
close ($f2);

isnt ($string1,  $string2, "Initial conditions: strings in files not equal");

my $response = dancer_response POST => '/upload', {
    files => [
        { filename => "${files}/1.txt", name => "file1" },
        { filename => "${files}/2.txt", name => "file2" },
    ]
};
is ($response->content, 'ne', "Content in uploaded files should not be normalized");

