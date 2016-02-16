use 5.022;

{
    package BecomeActiveObject;
    use Moose;
    use threads;
    use threads::shared;
    use namespace::autoclean;

    my $var :shared = 0;
    
    has 'out' => (
        is => 'rw',
        isa => 'Int',
    );
    
    sub BUILD {
        my $self = shift;
        my ($thr1,$thr2,$thr3) = (threads->create(\&do_something_1),threads->create(\&do_something_2),threads->create(\&do_something_3));
        $thr1->join && $thr2->join && $thr3->join;
        
        $self->out($var);
    }
    
    sub do_something_1 {
        my $self = shift;
        $var = 1.0;
    }
    
    sub do_something_2 {        
        my $self = shift;
        $var = 2.0;
    }
    
    sub do_something_3 {
        my $self = shift;
        $var = 3.0;
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $bao = BecomeActiveObject->new;
say $bao->out;