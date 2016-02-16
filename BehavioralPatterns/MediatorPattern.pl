use 5.022;

sub lil_john {
    my ($message, $from) = (shift, shift);
    my @response = qw(WHAT OKAY YEAH);
    
    say $response[int(rand(1) * 3)];
}

sub seagull {
    my ($message, $from) = (shift, shift);
    my @response = qw(MINE);
    
    say $response[0];
}

my $message_received_event_handler = \&lil_john;

{
    package Mediator;
    use Moose;
    use namespace::autoclean;
    
    sub send {
        my $self = shift;
        my ($message, $from) = (shift, shift);
        
        if (defined($message_received_event_handler)) {
            say "Sending '$message' from $from.";
            &$message_received_event_handler($message, $from);
        }
        
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Person;
    use Moose;
    use namespace::autoclean;
    
    has 'name' => (
        is => 'rw',
        isa => 'Str',
    );
    
    has '_mediator' => (
        is => 'ro',
        isa => 'Mediator',
        builder => '_build_mediator',
    );
    
    sub _build_mediator {
        my $self = shift;
        
        return Mediator->new;
    }
    
    sub receiver {
        my $self = shift;
        my ($message, $from) = (shift, shift);
        
        if ($from ne $self->name) {
            say "The " . $self->name . " received '$message' from $from";
        }
    }
    
    sub send {
        my $self = shift;
        my $message = shift;
        
        $self->_mediator->send($message, $self->name);
    }
    
    __PACKAGE__->meta->make_immutable;   
}

my $a = Person->new(name => 'zenbae');
$a->send('Hello!');
$a->send('Welcome!');
$a->send('Great!');
$a->send('Thanks, you\'ve been kind.');