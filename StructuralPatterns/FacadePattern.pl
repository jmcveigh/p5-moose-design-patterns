#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Processor;
    use Moose;
    use namespace::autoclean;
    
    sub freeze {
        my $self = shift;
        say "Processor : freeze";
    }
    
    sub jump {
        my $self = shift;
        my $position = shift;
        say "Processor : jump($position)";
    }
    
    sub execute {
        my $self = shift;
        say "Processor : execute";
    }
    
    __PACKAGE__->meta->make_immutable;
}


{
    package Memory;
    use Moose;
    use namespace::autoclean;
    
    sub load {
        my $self = shift;
        my ($position,$data) = (shift,shift);
        say "Memory : load(" . sprintf("%x",$position) . "," . sprintf("%x",$data) . ")";
    }
    
    __PACKAGE__->meta->make_immutable;
}

 {
    package Harddrive;
    use Moose;
    use namespace::autoclean;
    
    sub read {
        my $self = shift;
        my ($lba,$size) = (shift,shift);
        say "Harddrive : read(" . sprintf("%x",$lba) . ",$size)";
    }
    
    __PACKAGE__->meta->make_immutable;
}


{
    package ComputerFacade;
    use Moose;
    use namespace::autoclean;
    
    has '_processor' => (
        is => 'ro',
        isa => 'Processor',
        default => sub { Processor->new(); },        
    );
    
    has '_harddrive' => (
        is => 'ro',
        isa => 'Harddrive',
        default => sub { Harddrive->new(); },        
    );
    
    has '_memory' => (
        is => 'ro',
        isa => 'Memory',
        default => sub { Memory->new(); },    
    );
    
    sub start {
        my $self = shift;
        $self->_processor->freeze;
        $self->_memory->load(0xFEF1F0,$self->_harddrive->read(0xE1E1E0,8092));
        $self->_processor->execute;
    }
    
    __PACKAGE__->meta->make_immutable;    
}

my $computer_facade = ComputerFacade->new;
$computer_facade->start;