package Math::NT::BQF::Util;
use warnings;
use strict;
use Exporter::Tidy
    assert => [qw| 
        assert_bqf_tuple 
    |],
    other => [qw| 
        bqf_are_equal
        bqf_are_equivalen
    |];
use Carp;

sub bqf_are_equal  {
    my ($f,$g) = @_;
    return '' unless defined $f && blessed($f) && $f->isa('Math::NT::BQF');
    return '' unless defined $g && blessed($g) && $g->isa('Math::NT::BQF');
    $f->get_A == $g->get_A  &&
    $f->get_B == $g->get_B  &&
    $f->get_C == $g->get_C
}

sub bqf_are_equivalent  {
    my ($f,$g) = @_;
    return '' unless defined $f && blessed($f) && $f->isa('Math::NT::BQF');
    return '' unless defined $g && blessed($g) && $g->isa('Math::NT::BQF');
    confess "not finished"
}

# XXX typecheck not done!
sub assert_bqf_tuple  {
    my ($A,$B,$C,$type) = @_;
    confess "need an 'A' coefficient" unless defined $A;
    confess "need a 'B' coefficient"  unless defined $B;
    confess "need a 'C' coefficient"  unless defined $C;
    undef
}

1;

__END__

