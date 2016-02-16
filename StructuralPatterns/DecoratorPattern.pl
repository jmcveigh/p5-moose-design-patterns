use 5.022;

{
    package Coffee;
    use Moose;
    use namespace::autoclean;
        
    sub getCost {
        return 0.0;
    }
    
    sub getIngredients {
        return "Water";
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package SimpleCoffee;
    use Moose;
    extends 'Coffee';
    use namespace::autoclean;
    
    override 'getCost' => sub {
        return 0.80;
    };
    
    override 'getIngredients' => sub {
        return "Java";
    };
    
    __PACKAGE__->meta->make_immutable;
}

{
    package CoffeeDecorator;
    use Moose;
    extends 'Coffee';
    
    has c => (
        is => 'rw',
    );
    
    override 'getCost' => sub {
        my $self = shift;
        return $self->c->getCost;
    };
    
    override 'getIngredients' => sub {
        my $self = shift;
        return $self->c->getIngredients;
    };
}

{
    package WithSprinkles;
    use Moose;
    extends 'CoffeeDecorator';
    use namespace::autoclean;
    
    has '_meta' => (
        is => 'rw',
        builder => '_build_meta',
    );
    
    sub _build_meta {
        my $self = shift;
        return(__PACKAGE__->meta);
    }
    
    override 'getCost' => sub {
        my $self = shift;
        return $self->c->getCost + 0.5;
    };
    
    override 'getIngredients' => sub {
        my $self = shift;
        return $self->c->getIngredients . " Sprinkles";        
    };
    
    __PACKAGE__->meta->make_immutable;
}

{
    package WithMilk;
    use Moose;
    extends 'CoffeeDecorator';
    use namespace::autoclean;
    
    has '_meta' => (
        is => 'rw',
        builder => '_build_meta',
    );
    
    sub _build_meta {
        my $self = shift;
        return(__PACKAGE__->meta);
    }
    
    override 'getCost' => sub {
        my $self = shift;
        return $self->c->getCost + 0.2;
    };
    
    override 'getIngredients' => sub {
        my $self = shift;
        return $self->c->getIngredients . " Milk";        
    };
    
    __PACKAGE__->meta->make_immutable;
}

# main

my $c = SimpleCoffee->new();
$c = WithMilk->new(c => $c);
$c = WithSprinkles->new(c => $c);
say ($c->getIngredients, " ", sprintf("\$%2.2f", $c->getCost));