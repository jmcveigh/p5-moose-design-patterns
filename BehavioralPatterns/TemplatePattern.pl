use 5.022;

{
    package Game;
    use Moose;
    use namespace::autoclean;
    
    has 'players_count' => (
        is => 'rw',
        isa => 'Int',
    );
    
    sub init_game {
        return;
    }
    
    sub end_of_game {
        return;
    }
    
    sub make_play {
        return;
    }
    
    sub print_winner {
        return;
    }
    
    sub play_one_game {
        my $self = shift;
        my $players_count = shift;
        $self->init_game();
        
        my $j = 0;
        
        while (!$self->end_of_game) {
            $self->make_play($j);
            $j = ($j + 1) % $players_count;            
        }
        
        $self->print_winner;        
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Monopoly;
    use Moose;
    extends 'Game';
    use namespace::autoclean;
    
    override 'init_game' => sub {
        # initialize players
        # initialize money
    };
    
    override 'make_play' => sub {
        # process on turn of player    
    };
    
    override 'end_of_game' => sub {
        # return 1 if game is over
        # according to Monopoly rules
    };
    
    override 'print_winner' => sub {
        # display who won    
    };
    
    # ... specification declarations for Monopoly game
    __PACKAGE__->meta->make_immutable;
}

{
    package Chess;
    use Moose;
    extends 'Game';
    use namespace::autoclean;
    
    override 'init_game' => sub {
        # initialize sides
    };
    
    override 'make_play' => sub {
        # process on turn of player    
    };
    
    override 'end_of_game' => sub {
        # return 1 if game is over
        # according to Chess rules
    };
    
    override 'print_winner' => sub {
        # display who won    
    };
    
    # ... specification declarations for Chess game
    __PACKAGE__->meta->make_immutable;
}