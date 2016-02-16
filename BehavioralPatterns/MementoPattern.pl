use 5.022;

{
    package Originator;
    use Moose;
    use namespace::autoclean;
    
    has '_state' => (
        is => 'rw',
        isa => 'Str',
    );
    
    sub set_state {
        my $self = shift;
        my $state = shift;
        $self->_state($state);
        say "Originator setting state to : $state.";
    }
    
    sub save_to_memento {
        my $self = shift;
        say "Originator : Saving to Memento.";
        
        return Memento->new(state => $self->_state);
    }
    
    sub restore_from_memento {
        my $self = shift;
        my $memento = shift;
        
        $self->_state($memento->get_saved_state);
        say "Originator : State after restoring from Memento : " . $self->_state;
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Memento;
    use Moose;
    use namespace::autoclean;
    
    has 'state' => (
        is => 'rw',
        isa => 'Str',
    );
    
    sub get_saved_state {
        my $self = shift;
        return $self->state;
    }
    
    __PACKAGE__->meta->make_immutable;
}

my @saved_states;
my $orig = Originator->new;
$orig->set_state("State1");
$orig->set_state("State2");
push @saved_states, $orig->save_to_memento;
$orig->set_state("State3");
push @saved_states, $orig->save_to_memento;
$orig->set_state("State4");
$orig->restore_from_memento($saved_states[0]);