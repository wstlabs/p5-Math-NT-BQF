package Math::NT::BQF::Heavy;
use warnings;
use strict;
use Math::NT::BQF::Util qw(:all);
use Scalar::Util qw( refaddr );
use Moose;
# use Log::EZ; 

has A => ( is => 'rw', isa => 'Int', 'reader' => 'get_A', 'writer' => 'set_A' );
has B => ( is => 'rw', isa => 'Int', 'reader' => 'get_B', 'writer' => 'set_B' );
has C => ( is => 'rw', isa => 'Int', 'reader' => 'get_C', 'writer' => 'set_C' );

sub serial  {
    my $self = shift;
    return {
        'A' => $self->get_A, 'B' => $self->get_B, 'C' => $self->get_C
    }
}


1;

__END__



