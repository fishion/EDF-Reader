#!perl

use strict;
use warnings;
use lib qw(lib);

use Data::Dumper;
use Test::More tests => 22;

use_ok( 'EDF::Reader' );

my $file = 't/testfiles/events.txt';
ok (my $edf = EDF::Reader->new($file), 'parse file on construction');
ok (my $edf2 = EDF::Reader->new(), 'new oject no file');

is ($edf2->data, undef, 'no data yet');
ok ($edf2->read($file), 'slurp file');

is (ref($edf->fields), 'ARRAY', 'fields is a list');
is (ref($edf2->fields), 'ARRAY', 'fields is a list');
is (scalar @{$edf->fields}, scalar @{$edf2->fields}, 'same fields in both');
is (scalar @{$edf->fields}, 3, 'right number of fields');


is (ref($edf->data), 'ARRAY', 'data is a list');
is (ref($edf2->data), 'ARRAY', 'data is a list');

is (scalar @{$edf->data}, scalar @{$edf2->data}, 'same data in both');
is (scalar @{$edf->data}, 4 , 'right number of data');
ok ($edf->data->[0]->{name} !~ m/\n$/, 'no new line at end of name' );
ok ($edf->data->[0]->{date} !~ m/\n$/, 'no new line at end of date' );
ok ($edf->data->[0]->{desc} !~ m/\n$/, 'no new line at end of desc' );

# Try another one
$file = 't/testfiles/groups.txt';
ok($edf = EDF::Reader->new($file), 'parse file on construction');

is (scalar @{$edf->fields}, 7, 'right number of fields');
is(ref($edf->data), 'ARRAY', 'data is a list');
is (scalar @{$edf->data}, 2 , 'right number of data');
ok ($edf->data->[0]->{categories} !~ m/\s+$/, 'category list has no space at the end' );
ok ($edf->data->[1]->{url} =~ m/\w/, '2nd data has url' );
