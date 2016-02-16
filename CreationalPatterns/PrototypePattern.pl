#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Prototype;
    use Moose::Role;
    
    requires 'Clone';
    requires 'Hello'
}

{
    package ConcretePrototype1;
    use Moose;
    use Clone 'clone';
    with 'Prototype';
    use namespace::autoclean;
    
    sub Clone {
        my $self = shift;
        $self->new();
    }
    
    sub Hello {
        say 'Hello!';
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package ConcretePrototype2;
    use Moose;
    use Clone 'clone';
    with 'Prototype';
    use namespace::autoclean;
    
    sub Clone {
        my $self = shift;
        $self->new();
    }
    
    sub Hello {
        say 'Bonjourno!';
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $cp2 = ConcretePrototype2->Clone();
my $cp1 = ConcretePrototype1->Clone();

$cp2->Hello();
$cp1->Hello();
