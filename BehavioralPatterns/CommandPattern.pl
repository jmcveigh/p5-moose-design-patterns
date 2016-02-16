use 5.022;

my $switch = 0;

sub light_on {
    $switch = 1;
    say "Turn light on.";
}

sub light_off {
    $switch = 0;
    say "Turn light off.";
}

sub light_dimmer_up {
    say "Dim lights up." if $switch == 1;
}

sub light_dimmer_down {
    say "Dim lights down." if $switch == 1;
}

{
    package Command;
    use Moose::Role;
    
    requires qw(apply);
}

{
    package CommandFactory;
    use Moose;
    use namespace::autoclean;
    
    has '_commands' => (
        is => 'rw',
        isa => 'HashRef',
        default => sub { {}; },
    );
    
    sub add_command {
        my $self = shift;
        my ($name, $command) = (shift, shift);
        
        my %commands = %{$self->_commands};
        $commands{$name} = $command;
        
        $self->_commands(\%commands);
    }
    
    sub do_command {
        my $self = shift;
        my $name = shift;
        
        my %commands = %{$self->_commands};
        
        if (exists($commands{$name})) {
            my $command = \&{$commands{$name}};
            &$command;
        }
    }
    
    sub list_commands {
        my $self = shift;
        
        my %commands = %{$self->_commands};
        
        foreach my $key (keys(%commands)) {
            say "$key";
        }
        
    }
    
    sub BUILD {
        my $self = shift;
        
        $self->add_command("on", \&::light_on);
        $self->add_command("off", \&::light_off);
        $self->add_command("up", \&::light_dimmer_up);
        $self->add_command("down", \&::light_dimmer_down);
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $cf = CommandFactory->new;
$cf->do_command('on');
$cf->do_command('up');
$cf->do_command('down');
$cf->do_command('off');