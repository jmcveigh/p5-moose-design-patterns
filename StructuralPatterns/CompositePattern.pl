#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package CompositeRole;
    use Moose::Role;    
    
    requires 'CompositeMethod';
}

{
    package LeafComposite;
    use Moose;
    with 'CompositeRole';
    use namespace::autoclean;
    
    sub CompositeMethod {
        my $self = shift;
        say "LeafComposite: CompositeMethod";
    }
}

{
    package NormalComposite;
    use Moose;
    with 'CompositeRole';
    use namespace::autoclean;
    
    sub CompositeMethod {
        my $self = shift;
        say "NormalComposite: CompositeMethod";
    }
    
    sub DoSomethingMore {
        my $self = shift;
        say "NormalComposite: DoSomethingMore";
    }
}

{
    package Process;
    use Moose;
    use namespace::autoclean;
    
    has 'composite' => (
        is => 'rw',
        isa => 'CompositeRole',      
    );
    
    sub main {
        my $self = shift;
        my $c = shift;
        $self->composite($c);
        for my $m ($self->composite->meta->get_all_methods) {
            eval($m->fully_qualified_name);            
        }
    }
        
    __PACKAGE__->meta->make_immutable;
}

my $proc = Process->new();
$proc->main(LeafComposite->new());
$proc->main(NormalComposite->new());