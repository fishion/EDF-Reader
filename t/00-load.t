#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'EDF::Reader' );
}

diag( "Testing EDF::Reader $EDF::Reader::VERSION, Perl $], $^X" );
