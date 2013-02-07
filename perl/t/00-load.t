#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'GPIO' ) || print "Bail out!
";
}

diag( "Testing GPIO $GPIO::VERSION, Perl $], $^X" );
