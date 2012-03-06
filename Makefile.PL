use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Math::NT::BQF',
    AUTHOR              => q{WST <nobody@null.org>},
    VERSION_FROM        => 'lib/Math/NT/BQF.pm',
    ABSTRACT_FROM       => 'lib/Math/NT/BQF.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Class::Options' => 0,
        'Class::Tools' => 0.001,
        'Scalar::Util' => 0,
        'Log::EZ' => 0.001,
        'Readonly' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Math-NT-BQF-*' },
);
