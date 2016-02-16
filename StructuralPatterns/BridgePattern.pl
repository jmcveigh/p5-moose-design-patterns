#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Bridge1;
    use Moose;
    with 'AbstractBridgeRole';        
    use namespace::autoclean;
    
    sub Function1 {
        my $self = shift;
        say "Not implemented exception thrown by Bridge1."
    }
    
    sub Function2 {
        my $self = shift;
        say "Not implemented exception thrown by Bridge1."
    }
    
    __PACKAGE__->meta->make_immutable;    
}

{
    package Bridge2;
    use Moose;
    with 'AbstractBridgeRole';
    use namespace::autoclean;
    
    sub Function1 {
       my $self = shift;
        say "Not implemented exception thrown by Bridge2."
    }
    
    sub Function2 {
        my $self = shift;
        say "Not implemented exception thrown by Bridge2."
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package AbstractBridgeRole;
    use Moose::Role;
    
    requires qw(Function1 Function2);
}

{
   package AbstractBridge;
   use Moose;   
   
    has 'bridge' => (
        is => 'rw',
        isa => 'AbstractBridgeRole',
        handles => [qw(Function1 Function2)],
    );
}

my $ab1 = AbstractBridge->new(bridge => Bridge1->new());
$ab1->bridge->Function1();
$ab1->bridge->Function2();

my $ab2 = AbstractBridge->new(bridge => Bridge2->new());
$ab2->bridge->Function1();
$ab2->bridge->Function2();