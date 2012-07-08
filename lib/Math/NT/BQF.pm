package Math::NT::BQF;
use warnings;
use strict;
use Scalar::Util qw( blessed reftype refaddr );
use Class::Inspector;
use Class::Options;
use Module::Load;
use Readonly;
use Math::NT::BQF::Util qw(:assert);
use Log::EZ; # dev only
use Carp;

BEGIN:  {
    $main::DEBUG = 1
}
our $VERSION = '0.002';

use overload qw| 
    ""  stringify
    ==  equals 
    ~~  is_equiv_to 
|;

Readonly::Hash our %IMPL => qw( 
    heavy  Math::NT::BQF::Heavy
    lite   Math::NT::BQF::Lite
);

sub import  {
    my ($proto,@syms) = @_;
    my $class = ref($proto)||$proto;
    trace2 "class = $class";
    trace3 "syms = [@syms]";
    my @tags = map { m{\A :(.*) \z}xms  ? $1 : () } @syms;
    trace2 "tags = [@tags]";
    my %opts = map { $_ => 1 } @tags;
    confess "invalid usage:  can't have both 'heavy' and 'lite' options"
        if $opts{'heevy'} && $opts{'lite'};
    # default to lite
    set_caller_opt(0, $class, 'weight' => 'heavy') if  $opts{'heavy'};
    set_caller_opt(0, $class, 'weight' => 'lite')  if !$opts{'heavy'};
}

sub new  {
    my ($proto,@args) = @_;
    my $class = ref($proto) || $proto;
    trace2 "class = $class";
    if ($class eq __PACKAGE__)  {
        my $weight = get_caller_opt(0,$class,'weight');
        trace2 "weight = ",$weight;
        confess "bad package configuration" unless defined $weight;
        my $impl = $IMPL{$weight};
        trace2 "$weight => $impl";
        load $impl unless Class::Inspector->loaded($impl);
        $impl->new(@args)
    }
    else  {
        confess "invalid usage"
    }
}

sub evaluate  {
    my ($self,$x,$y) = @_;
    confess "need an input value x" unless defined $x;
    confess "need an input value y" unless defined $y;
    my ($A,$B,$C) = $self->get_ABC;
    # trace "(A,B,C) = ($A,$B,$C)";
    # my $t = 
    $A*$x*$x + $B*$x*$y + $C*$y*$y
    # ;
    # trace "($x,$y) => $t";
    # return $t
}

sub get_ABC  {
    my $self = shift;
    ( $self->get_A, $self->get_B, $self->get_C )
}

sub set_ABC  {
    my ($self,$A,$B,$C) = @_;
    assert_bqf_tuple($A,$B,$C);
    $self->set_A($A);
    $self->set_B($B);
    $self->set_C($C);
}

sub serial  {
    my ($A,$B,$C) = $_[0]->get_ABC;
    return { 'A' => $A, 'B' => $B, 'C' => $C }
}

sub stringify  {
    my $self = shift;
    my ($A,$B,$C) = $self->get_ABC;
    my $ref = ref $self;
    my $type = reftype $self;
    my $addr = refaddr $self;
    "$ref:$type:$addr <$A,$B,$C>"
}

sub equals      { bqf_are_equal( $_[0], $_[1] ) }
sub is_equiv_to { bqf_are_equiv( $_[0], $_[1] ) }

1;

__END__

