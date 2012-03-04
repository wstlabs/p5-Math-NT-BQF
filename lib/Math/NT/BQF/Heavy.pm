package Math::NT::BQF::Heavy;
use warnings;
use strict;
use Log::Inline;
use Math::NT::BQF::Util qw(:all);
use Scalar::Util qw( refaddr );
use Moose;

# our @ISA = qw('Math::NT::BQF');

has A => ( is => 'rw', isa => 'Int', 'reader' => 'get_A', 'writer' => 'set_A' );
has B => ( is => 'rw', isa => 'Int', 'reader' => 'get_B', 'writer' => 'set_B' );
has C => ( is => 'rw', isa => 'Int', 'reader' => 'get_C', 'writer' => 'set_C' );
# has B => ( is => 'rw', isa => 'Int');
# has C => ( is => 'rw', isa => 'Int');

# sub get_A { $_[0]->A }
# sub get_B { $_[0]->B }
# sub get_C { $_[0]->C }

sub serial  {
    my $self = shift;
    return {
        'A' => $self->get_A, 'B' => $self->get_B, 'C' => $self->get_C
    }
}


1;

__END__



package Math::NT::BQF::Lite;
use warnings;
use strict;
use Log::Inline;
use Math::NT::BQF::Util qw(:all);
use Scalar::Util qw( refaddr );
use base 'Math::NT::BQF';

sub evaluate  {
    my ($self,$x) = @_; 
    confess "need an input value" unless defined $x;
    my ($A,$B,$C) = $self->get_ABC;
    $A*$x*$x + $B*$x*$y * $C*$y*$y
}

1;

__END__


