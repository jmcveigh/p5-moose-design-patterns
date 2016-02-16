use 5.022;

{
    package Subject;
    use Moose;
    use namespace::autoclean;
    
    has 'observers' => (
        is => 'rw',
        isa => 'ArrayRef',
        default => sub { [] },
    );
    
    has 'value' => (
        is => 'rw',
        isa => 'Int',
        default => sub { 0; },
    );
    
    sub set_value {
        my $self = shift;
        my $value = shift;
        if ($value > $self->value) {
            $self->notify;
        }
        
        $self->value($value);        
    }
    
    sub get_value {
        my $self = shift;
        return $self->value;
    }
    
    sub subscribe {
        my $self = shift;
        my $observer = shift;
        my @observers = @{$self->observers};
        push @observers, $observer;
        $self->observers(\@observers);
    }
    
    sub unsubscribe {
        my $self = shift;
        my $observer = shift;
        my @observers = @{$self->observers};
        my $i = 0;
        
        for my $item (@observers) {
            $i++;
            if ($item == $observer) {
                @observers = splice(@observers,$i,1);
                last;
            }
        }
    }
    
    sub notify {
        my $self = shift;
        my @observers = @{$self->observers};
        
        foreach my $item (@observers) {
            $item->update;
        }
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Observer;
    use Moose::Role;
    
    has 'observer_name' => (
        is => 'rw',
        isa => 'Str',
    );
    
    requires qw(update)
}

{
    package Receiving;
    use Moose;
    with 'Observer';
    
    sub update {
        say "Received new widget.";
    }
}

{
    package Storage;
    use Moose;
    with 'Observer';
    
    sub update {
        say "Stored new widget.";
    }
}

my $s = Subject->new;
my $o1 = Receiving->new;
my $o2 = Storage->new;

$s->subscribe($o1);
$s->subscribe($o2);

$s->set_value($s->get_value + 1);
$s->set_value($s->get_value + 1);
$s->set_value($s->get_value + 1);
$s->set_value($s->get_value + 1);
$s->set_value($s->get_value + 1);
say "There were a total of " . $s->get_value . " widgets stored and received.";