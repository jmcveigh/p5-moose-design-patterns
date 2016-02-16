use 5.022;

{
    package Helper;
    use Moose;
    use namespace::autoclean;
    
    has 'colour' => (
        is => 'ro',
        isa => 'Str',
        default => sub { 'orange'; },
    );
    __PACKAGE__->meta->make_immutable;
}

{
    package Foo;
    use Moose;
    use namespace::autoclean;
    
    has '_helper' => (
        is => 'rw',
        isa => 'Helper',
        default => sub { undef; },
    );
    
    sub get_helper {
        my $self = shift;
        if (!defined($self->_helper)) {
            $self->_helper(Helper->new);
        }
        
        return $self->_helper        
    }
    
    __PACKAGE__->meta->make_immutable;
}