use 5.022;

{
    package Worker;
    use Moose;
    use threads;
    use threads::shared;
    use namespace::autoclean;
    
    my $job_in_progress :shared = 0;
    my $var :shared = 0;
    
    sub do_job {
        my $self = shift;
        my $thr1 = threads->create(\&job);
        $thr1->join;
        say $var;
    }
    sub job_begin {
        my $self = shift;
        if ($job_in_progress) {
            return;
        }
        
        return($job_in_progress = 1);
    }
    
    sub job_end {
        my $self = shift;
        $job_in_progress = 0;
    }
    
    sub job {        
        if (job_begin) {            
            $var = 1.0;
            job_end;
        }
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $wrk = Worker->new;
$wrk->do_job;