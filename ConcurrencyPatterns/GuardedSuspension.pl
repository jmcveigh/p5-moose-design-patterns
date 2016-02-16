use 5.022;

{
    package Worker;
    use Moose;
    use Try::Tiny;
    use threads;
    use threads::shared;
    use namespace::autoclean;
    
    my $val :shared = 0;
    
    sub do_method {
        $val = 1.0;
    }
    
    sub report {
        my $self = shift;
        say $val;
    }
    
    sub guard_precondition {
        return 1 if $val == 0;
        return;
    }
    
    sub guard_method {
        while (!guard_precondition) {
            try {
                threads->yield;    
            } catch {
                # err
            }            
        }
        
        do_method;
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $wrk = Worker->new;
$wrk->guard_method;
$wrk->report;