use 5.022;

{
    package CarElementVisitor;
    use Moose::Role;
    
    requires qw(visit_wheel visit_engine visit_body visit_car);
}

{
    package CarElement;
    use Moose::Role;
    
    requires qw(accept);
}

{
    package Wheel;
    use Moose;
    with 'CarElement';
    use namespace::autoclean;
    
    has 'name' => (
        is => 'rw',
        isa => 'Str',
    );
    
    sub accept {
        my $self = shift;
        my $visitor = shift;
        
        $visitor->visit_wheel($self);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Engine;
    use Moose;
    with 'CarElement';
    use namespace::autoclean;
    
    has 'name' => (
        is => 'rw',
        isa => 'Str',
    );
    
    sub accept {
        my $self = shift;
        my $visitor = shift;
        
        $visitor->visit_engine($self);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Body;
    use Moose;
    with 'CarElement';
    use namespace::autoclean;
    
    has 'name' => (
        is => 'rw',
        isa => 'Str',
    );
    
    sub accept {
        my $self = shift;
        my $visitor = shift;
        
        $visitor->visit_body($self);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Car;
    use Moose;
    with 'CarElement';
    use namespace::autoclean;
    
    has 'name' => (
        is => 'rw',
        isa => 'Str',
    );
    
    has 'elements' => (
        is => 'rw',
        isa => 'ArrayRef[Object]',
        builder => '_build_car_elements',
    );
        
    sub _build_car_elements{
        my $self = shift;
        my @elements;
        
        push(@elements, Wheel->new(name => 'front left'));
        push(@elements, Wheel->new(name => 'front right'));
        push(@elements, Wheel->new(name => 'back left'));
        push(@elements, Wheel->new(name => 'back right'));
        push(@elements, Engine->new(name => '6 Cylinder'));
        push(@elements, Body->new(name => 'Coupe'));
        
        return \@elements;
    }
    
    sub accept {
        my $self = shift;
        my $visitor = shift;
        my @elements = @{$self->elements};
        
        for my $el (@elements) {
            $el->accept($visitor);
        }
        
        $visitor->visit_car($self);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package CarElementVisitor_Print;
    use Moose;
    with 'CarElementVisitor';
    
    sub visit_wheel {
        my $self = shift;
        my $wheel = shift;
        say "Visiting " . $wheel->name . " wheel.";
    }
    
    sub visit_engine {
        my $self = shift;
        my $engine = shift;
        say "Visiting " . $engine->name . " engine.";
    }
    
    sub visit_body {
        my $self = shift;
        my $body = shift;
        say "Visiting " . $body->name . " body.";
    }
    
    sub visit_car {
        my $self = shift;
        my $car = shift;
        say "Visiting " . $car->name . " wheel.";
    }
}

{
    package CarElementVisitor_Do;
    use Moose;
    with 'CarElementVisitor';
    
    sub visit_wheel {
        my $self = shift;
        my $wheel = shift;
        say "Kicking " . $wheel->name . " wheel.";
    }
    
    sub visit_engine {
        my $self = shift;
        my $engine = shift;
        say "Starting " . $engine->name . " engine.";
    }
    
    sub visit_body {
        my $self = shift;
        my $body = shift;
        say "Moving " . $body->name . " body.";
    }
    
    sub visit_car {
        my $self = shift;
        my $car = shift;
        say "Starting " . $car->name . " car.";
    }
}

my $car = Car->new(name => 'Ford');
$car->accept(CarElementVisitor_Print->new);
$car->accept(CarElementVisitor_Do->new);