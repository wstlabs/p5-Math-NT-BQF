package Math::NT::BQF;
use warnings;
use strict;
use Scalar::Util qw( blessed reftype refaddr );
use Class::Inspector;
use Class::Options;
use Module::Load;
use Log::EZ; # dev only
use Readonly;
use Carp;
use Math::NT::BQF::Util qw(:assert);

BEGIN:  {
    $main::DEBUG = 1
}
our $VERSION = '0.001';

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
    # trace "self = $self [$x,$y]";
    my ($A,$B,$C) = $self->get_ABC;
    $A*$x*$x + $B*$x*$y * $C*$y*$y
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

=head1 NAME

Math::NT::BQF - binary quadratic forms 

=head1 VERSION

Version 0.01

=cut


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Math::NT::BQF;

    my $foo = Math::NT::BQF->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

highlinelabs, C<< <nada at null.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-math-nt-bqf at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-NT-BQF>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::NT::BQF


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-NT-BQF>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Math-NT-BQF>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Math-NT-BQF>

=item * Search CPAN

L<http://search.cpan.org/dist/Math-NT-BQF/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 highlinelabs.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Math::NT::BQF
