use strict;
use warnings;
use Log::Inline;
use Getopt::Long;
require Math::NT::BQF;

our $DEBUG = 1;

GetVerbose();
GetOptions(
    'heavy' => \our $HEAVY,
    'lite'  => \our $LITE
);

trace2 "..";
my @tags;
push @tags, ':heavy' if $HEAVY;
push @tags, ':lite'  if $LITE;
Math::NT::BQF->import(@tags);
my ($x,$y) = 
    @ARGV == 2 ? @ARGV : 
    @ARGV == 0 ? ()    : bail_usage();

my $F = Math::NT::BQF->new(1,0,1);
my $G = Math::NT::BQF->new(2,1,3);
trace "F = $F";
trace "G = $G";
if (defined $x && defined $y)  {
    trace "F = ",$F->serial;
    my $w = $F->($x,$y);
    trace "F($x,$y) = $w";
    trace "G = ",$G->serial;
    my $z = $G->($x,$y);
    trace "G($x,$y) = $z";
}


sub bail_usage  {
print<<__;
usage:  perl $0 [--heavy|--lite] [x y]
__
exit 1 
}
