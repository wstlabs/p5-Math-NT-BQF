package Math::NT::BQF::Visit;
use warnings;
use strict;
use Params::Validate;
use Assert::Std qw(:types);
use Exporter::Tidy
    other => [qw| 
        visit_simple
    |];
use Carp;
use Log::EZ;

sub visit_simple  {
    my $f     = shift // confess "need a BQF";
    my $R     = shift // confess "need a quadratic radius";
    my $each  = shift // confess "need a visitor";
    my $n = 0;
    goto DONE if $R <= 0;
    my $spec = [0,0,0,0];
    while (spec2sign($spec) >= 0)  {
        trace "..";
        trace "spec == @$spec";
        $n += visit_diag($f,$R,$each,$spec);
        trace "{n, spec } = { $n, @$spec }";
        widen_spec($spec);
        trace "wide => @$spec";
    }
    DONE:  return { 'n' => $n }
}

sub visit_diag  {
    my $f     = shift // confess "need a BQF";
    my $R     = shift // confess "need a quadratic radius";
    my $each  = shift // confess "need a visitor";
    my $spec  = shift // confess "need a diag spec";
    my ($x0,$y0,$x1,$y1) = split_spec($spec); 
    confess "invalid usage" unless spec2sign($spec) >= 0;
    my ($x,$y,$n) = ($x0,$y0,0);
    while ($x <= $x1 && $y >= $y1)  { 
        my $t = $f->($x,$y);
        trace "($x,$y) => $t";
        if ($t > $R)  {
            if ($x == $x0)  { 
                $x0++; $y0-- 
                ; trace "bumpx => $x0 $y0 $x1 $y1";
            }
            elsif ($y == $y1)  { 
                $x1--; $y1++ 
                ; trace "bumpy => $x0 $y0 $x1 $y1";
            }
        }
        else  {
            $each->($x,$y,$t);
            $n++
        }
        $x++; $y--;
    }
    @$spec = ($x0,$y0,$x1,$y1);
    return $n
}

sub widen_spec  {
    my $spec = shift; 
    my ($x0,$y0,$x1,$y1) = split_spec($spec); 
    @$spec = ($x0,$y0+1,$x1+1,$y1)
}

sub visit_diag_ez  {
    my $xx    = shift // confess "need a diag spec";
    my $f     = shift // confess "need a BQF";
    my $each  = shift // confess "need a visitor";
    my ($x0,$y0,$x1,$y1) = split_diag_spec($xx); 
    my ($x,$y,$n) = ($x0,$y0,0);
    while ($x <= $x1 && $y >= $y0)  { 
        my $t = $f->($x,$y);
        $each->($x,$y,$t);
        $x++; $y--; $n++
    }
    return $n
}

sub split_spec  {
    my $xx   = shift // confess "need a diag spec";
    assert_array_ref($xx);
    my ($x0,$y0,$x1,$y1) = @$xx;
    for ($x0,$y0,$x1,$y1) { confess "invalid diag spec" unless defined $_ }; 
    ($x0,$y0,$x1,$y1)
}

sub spec2sign  {
    my ($x0,$y0,$x1,$y1) = split_spec(shift); 
    $x1 <=> $x0
}


sub visit_where  {
    my $f = shift // confess "need a BQF";
    my %o = validate (
        @_, {
        }
    );
}

1;

