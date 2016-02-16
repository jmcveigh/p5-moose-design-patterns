use 5.022;

{
    package Account;
    use Moose;
    use threads;
    use threads::shared;
    use namespace::autoclean;
    
    my $val :shared = 0;
    my $lck :shared = 0;
    
    sub deposit {
        my $x = shift;
        lock($lck);
        $val += $x;
    }
    
    sub withdrawl {
        my $x = shift;
        lock($lck);
        $val -= $x;
    }
    
    __PACKAGE__->meta->make_immutable;
}