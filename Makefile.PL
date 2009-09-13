use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'EDF::Reader',
    AUTHOR              => 'Alex Monney <alexmonney@hotmail.com>',
    VERSION_FROM        => 'lib/EDF/Reader.pm',
    ABSTRACT_FROM       => 'lib/EDF/Reader.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'EDF-Reader-*' },
);
