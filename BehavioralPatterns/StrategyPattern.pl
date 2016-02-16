use 5.022;

{
    package Table;
    use Moose;
    use namespace::autoclean;
    
    has '_drinks' => (
        is => 'rw',
        isa => 'ArrayRef',
        default => sub { []; },
    );
    
    has 'strategy' => (
        is => 'rw',
        isa => 'BillingStrategy',
    );
    
    sub add {
        my $self = shift;
        my ($p,$q) = (shift, shift);
        my @drinks = @{$self->_drinks};
        push @drinks, $self->strategy->get_actual_price($p * $q);
        $self->_drinks(\@drinks);
    }
    
    sub report {
        my $self = shift;
        my $sum = 0;
        
        my @drinks = @{$self->_drinks};
        for my $i (@drinks) {
            $sum += $i;
        }
        
        say "Total due: " . sprintf("%.2f", $sum);
        
        $self->_drinks([]);
    }
    
    sub set_strategy {
        my $self = shift;
        my $strategy = shift;
        
        $self->strategy($strategy);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package BillingStrategy;
    use Moose::Role;
    
    requires qw(get_actual_price);
}

{
    package NormalStrategy;
    use Moose;
    with 'BillingStrategy';
    
    sub get_actual_price {
        my $self = shift;
        my $raw = shift;
        
        return($raw);
    }
}

{
    package HappyHourStrategy;
    use Moose;
    with 'BillingStrategy';
    
    sub get_actual_price {
        my $self = shift;
        my $raw = shift;
        
        return($raw * 0.50);
    }
}

my $a = Table->new(strategy => NormalStrategy->new);
$a->add(5.60, 1);
$a->set_strategy(HappyHourStrategy->new);
$a->add(2.99, 2);

my $b = Table->new(strategy => HappyHourStrategy->new);
$b->add(6.40, 2);
$b->add(5.60, 1);
$b->report;
$a->report;
$b->add(5.60, 2);
$b->add(2.99, 1);
$b->report;