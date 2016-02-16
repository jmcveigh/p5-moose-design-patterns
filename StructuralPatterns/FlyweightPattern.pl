use 5.022;

{
    package CoffeeFlavour;
    use Moose;
    use namespace::autoclean;
    
    has 'flavour' => (
        is => 'rw',
        isa => 'Str',
    );
    
    sub to_string {
        my $self = shift;
        return "a hot cup of " . $self->flavour;
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package CoffeeFlavours;
    use Moose;
    use namespace::autoclean;
    
    has '_count' => (
        is => 'rw',
        default => sub { 0; },
    );
    
    has '_cache' => (
        is => 'rw',
        isa => 'HashRef[CoffeeFlavour]',
        default => sub { {}; },
    );
    
    sub count {
        my $self = shift;
        return($self->_count);
    }
    
    sub apply {
        my $self = shift;
        my $key = shift;
        
        my %cache = %{$self->_cache};
        
        if (!exists($cache{$key})) {
            $cache{$key} = CoffeeFlavour->new(flavour => $key);
            $self->_count($self->_count + 1);
            $self->_cache(\%cache);
        }
        
        return($cache{$key});
    }
    
    sub report {
        my $self = shift;
        return($self->_count);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Order;
    use Moose;
    use namespace::autoclean;
    
    has 'flavour' => (
        is => 'rw',
        isa => 'CoffeeFlavour',
    );
    
    has 'table' => (
        is => 'rw',
        isa => 'Int',
    );
    
    sub serve {
        my $self = shift;
        return "Serving " . $self->flavour->to_string . " to table number " . $self->table;
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package CoffeeShop;
    use Moose;
    use namespace::autoclean;
    
    has '_flavours' => (
        is => 'rw',
        isa => 'CoffeeFlavours',
        default => sub { CoffeeFlavours->new; },
    );
    
    has 'orders' => (
        is => 'rw',
        isa => 'ArrayRef',
        default => sub { [] },
    );
    
    sub take_order {
        my $self = shift;
        my ($table,$flavour_name) = (shift,shift);
        my $this_order = Order->new(table => $table, flavour => $self->_flavours->apply($flavour_name));
        push @{$self->orders}, $this_order;
    }
    
    sub report {
        my $self = shift;
        my @orders = @{$self->orders};
        foreach my $order (@orders) {
            say $order->serve;
        }
        
        say "This coffee shop has " . $self->_flavours->count . " flavours!"
    }
}


my $coffee_shop = CoffeeShop->new;
$coffee_shop->take_order(121,"Latte");
$coffee_shop->take_order(121,"Latte");
$coffee_shop->take_order(121,"Latte");
$coffee_shop->take_order(121,"Latte");
$coffee_shop->take_order(121,"Latte");
$coffee_shop->take_order(121,"Esspresso");
$coffee_shop->take_order(80,"Esspresso");
$coffee_shop->take_order(90,"Earl Grey");
$coffee_shop->take_order(790,"Earl Grey");
$coffee_shop->take_order(721,"Joe");
$coffee_shop->report;