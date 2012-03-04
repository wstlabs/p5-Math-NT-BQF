package Math::NT::BQF::Lite;
use warnings;
use strict;
use Log::Inline;
use Math::NT::BQF::Util qw(:all);
use Scalar::Util qw( refaddr );
use base 'Math::NT::BQF';
use Carp;

{
    my (%A,%B,%C);
    sub get_A  { $A{ refaddr $_[0] } }
    sub get_B  { $B{ refaddr $_[0] } }
    sub get_C  { $C{ refaddr $_[0] } }
    sub set_A  { $A{ refaddr $_[0] } = $_[1] }
    sub set_B  { $B{ refaddr $_[0] } = $_[1] }
    sub set_C  { $C{ refaddr $_[0] } = $_[1] }
    sub del_A  { delete $A{ refaddr $_[0] } }
    sub del_B  { delete $B{ refaddr $_[0] } } 
    sub del_C  { delete $C{ refaddr $_[0] } }
    my (%CODE,%REF); 
    sub set_inst  {
        my ($ref,$code) = @_;
        $CODE{refaddr $ref} = $code;
        $REF{refaddr $code} = $ref
    }
    sub get_inst  {
        my $ref = shift;
        $CODE{refaddr $ref}
    }
    sub DELETE  { 
        my $self = shift;
        $self->del_A;
        $self->del_B;
        $self->del_C;
        my $ref = $REF{refaddr $self};
        delete $CODE{refaddr $ref} if $ref;
        delete $REF{ refaddr $self};
    }
}

sub new  {
    my ($proto,$A,$B,$C) = @_;
    my $class = ref($proto) || $proto;
    my $inst  = bless instance(), $class;
    $inst->set_ABC($A,$B,$C);
    return $inst
}

# creates raw (unblessed) instance material.  since we'd like our
# basetypes to be coderefs, we need to generate a fresh lexical closure
# (i.e. a closure around a fresh lexical symbol, in our case an anonymous 
# scalar, $ref).  
#
# however, we have a slight problem:  our newley created coderef doesn't know 
# how to find itself (i.e. "$self") once executed.  to get around this, we 
# use your encapsulated storage to establish a two-way binding between
# our bound lexical ($ref) and our coderef ($inst).  this binding is then
# accessed via eval_form_at_ref, below, to infer $inst from $ref.
#
# finally, we have to ensure that when instances are disposed of, that
# the bindings we just created are disposed also (along with all other 
# object properties and attributes); this is handled in the DESTROY sub
# up in the inside-out block, above. 
#
sub instance  {
    my $ref = \do { my $anon_scalar } ; 
    # trace2 "ref = $ref";
    my $inst = sub { _eval_form_at_ref($ref,@_) };
    # trace "$ref => $inst";
    set_inst($ref,$inst);
    return $inst
}

sub _eval_form_at_ref  {
    my ($ref,$x,$y) = @_;
    # trace2 "ref = $ref, x = $x, y = $y";
    my $inst = get_inst($ref);
    # trace  "$ref => $inst  [$x,$y]";
    $inst->evaluate($x,$y)
}

1;

__END__

