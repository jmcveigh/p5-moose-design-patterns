use 5.020;

{
    package Client;
    use Moose::Role;

    requires qw(proc);
}

{
    package Fizz;
    use Moose;

    sub fizz {
        my $self = shift;
        my $repeat = shift;
        say "Fizz! " x $repeat;
    }
}

{
    package Bang;
    use Moose;
    with 'Client';

    sub proc {
        say "Bang!";
    }
}

{
    package FizzClientAdaptor;
    use Moose;
    with 'Client';

    has 'fizz' => (
        is => 'rw',
        isa => 'Fizz',
    );

    has 'repeat' => (
        is => 'rw',
        isa => 'Int',
    );

    sub BUILD {
        my $self = shift;
        $self->fizz(Fizz->new());
    }

    sub proc {
        my $self = shift;
        $self->fizz->fizz($self->repeat);
    }
}
    
{
    package Process;
    use Moose;
    use namespace::autoclean;
    
    has 'client' => (
        is => 'rw',
        isa => 'Client',      
    );
    
    sub main {
        my $self = shift;
        my $c = shift;
        $self->client($c);
        $self->client->proc;        
    }
        
    __PACKAGE__->meta->make_immutable;
}

my $proc = Process->new();
$proc->main(FizzClientAdaptor->new(repeat => 4));
$proc->main(Bang->new());
