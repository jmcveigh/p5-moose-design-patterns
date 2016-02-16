#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Button;    
    use Moose::Role;    
        
    requires 'paint';
}

{
    package Label;    
    use Moose::Role;
        
    requires 'paint';
}


{
    package GUIFactory;    
    use Moose::Role;
        
    requires 'createButton';
    requires 'createLabel';
    
}

{
    package Win::Factory;    
    use Moose;
    use namespace::autoclean;
    
    with 'GUIFactory';
    
    sub createButton {
        return(Win::Button->new());
    }
    
    sub createLabel {
        return(Win::Label->new()); 
    }
    
    __PACKAGE__->meta->make_immutable;
}


{
    package OSX::Factory;    
    use Moose;
    use namespace::autoclean;
    with 'GUIFactory';
    
    sub createButton {
        return(OSX::Button->new());
    }
    
    sub createLabel {
        return(OSX::Label->new());
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package OSX::Button;    
    use Moose;
    use namespace::autoclean;
    with 'Button';
    
    sub paint {
        say "I'm an OSX::Button."
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package OSX::Label;    
    use Moose;
    use namespace::autoclean;
    with 'Label';
    
    sub paint {
        say "I'm an OSX::Label."
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Win::Button;    
    use Moose;
    use namespace::autoclean;
    with 'Button';
    
    sub paint {
        say "I'm a Win::Button."
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Win::Label;    
    use Moose;
    use namespace::autoclean;
    with 'Label';
    
    sub paint {
        say "I'm a Win::Label."
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Application;        
    use Moose;
    use namespace::autoclean;
    
    sub Application {
        my $self = shift;
        my $factory = shift;
        my ($button,$label) = ($factory->createButton(),$factory->createLabel());
        $button->paint();
        $label->paint();
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package ApplicationRunner;    
    use Moose;
    use Moose::Util::TypeConstraints;
    use namespace::autoclean;
    
    enum 'OS', [qw(osx win)];
    
    has '_default_os' => (
        is => 'ro',
        isa => 'OS',
        default => 'win',
    );    
    
    sub main {
        my $self = shift;
        my $factory = $self->createFactory($self->_default_os);
        my $application = Application->new();
        $application->Application($factory);
    }
    
    sub createFactory {
        
        my $self = shift;
        my $os = shift;
        my $factory;
        
        given($os) {
            when(/win/) {
                $factory = Win::Factory->new();
            }
            
            when(/osx/) {
                $factory = OSX::Factory->new();
            }
        }
        
        return($factory);
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $ar = ApplicationRunner->new();
$ar->main();