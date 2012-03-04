#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'Math::NT::BQF' ) || print "no good!"; 
    use_ok( 'Math::NT::BQF::all' ) || print "no good!"; 
    use_ok( 'Math::NT::BQF::Util' ) || print "no good!"; 
}

diag( "Testing Math::NT::BQF $Math::NT::BQF::VERSION, Perl $], $^X" );
