use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Math::NT::BQF',
    AUTHOR              => q{highlinelabs <nada@null.org>},
    VERSION_FROM        => 'lib/Math/NT/BQF.pm',
    ABSTRACT_FROM       => 'lib/Math/NT/BQF.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Class::Options' => 0,
        'Class::Utils' => 0,
        'Scalar::Util' => 0,
        'Log::Inline' => 0,
        'Readonly' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Math-NT-BQF-*' },
);
