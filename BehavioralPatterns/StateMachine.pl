use 5.022;

{
    package Statelike;
    use Moose::Role;
    
    requires qw(write_name);
}

{
    package State_LowerCase;
    use Moose;
    with 'Statelike';
    use namespace::autoclean;
    
    sub write_name {
        my $self = shift;
        my ($context, $name) = (shift, shift);
        
        say lc($name);   
        
        $context->set_state(State_MultipleUpperCase->new);
    };
    
    __PACKAGE__->meta->make_immutable;
}

{
    package State_MultipleUpperCase;
    use Moose;
    with 'Statelike';
    use namespace::autoclean;
    
    our $counter = 0;
    
    sub write_name {
        my $self = shift;
        my ($context, $name) = (shift, shift);
        
        $counter++;
        
        say uc($name);   
        
        if ($counter > 1) {
            $context->set_state(State_LowerCase->new);
        }
    };
    
    __PACKAGE__->meta->make_immutable;
}

{
    package StateContext;
    use Moose;
    use namespace::autoclean;
    
    has '_state' => (
        is => 'rw',
        isa => 'Statelike',
        builder => '_build_state',
    );
    
    sub _build_state {
        return(State_LowerCase->new);
    }
    
    sub set_state {
        my $self = shift;
        my $new_state = shift;
        $self->_state($new_state);
        
        return 1;
    }
    
    sub write_name {
        my $self = shift;
        my $name = shift;
        
        $self->_state->write_name($self, $name);
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $state_machine = StateContext->new;
$state_machine->write_name('Huie');
$state_machine->write_name('Dewie');
$state_machine->write_name('Louis');
$state_machine->write_name('Scroodge');