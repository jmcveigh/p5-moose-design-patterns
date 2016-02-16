#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package LazyInstantiator;
    use Moose;
    use namespace::autoclean;
    
    
    has 'fruit_set' => (
        is => 'ro',
        isa => 'FruitSet',
        builder => '_build_fruit_set',
        handles => [qw(all has_fruit get_fruit insert_fruit)],
    );
    
    sub _build_fruit_set {
        return(FruitSet->new());
    }
    
    sub get_fruit_by_type_name {
        my $self = shift;
        my $type = shift;
        my $fruit;                
        
        if ($self->fruit_set->has_fruit($type)) {            
            $fruit = $self->fruit_set->get_fruit($type);
        } else {
            $fruit = Fruit->new( type  => $type );            
            $self->fruit_set->insert_fruit($type,$fruit);
        }
        
        return($fruit);
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package FruitSet;
    use Moose;
    use Set::Scalar;
    use namespace::autoclean;
    use Data::Dumper;
    
    has '_set' => (
        is => 'ro',
        isa => 'Set::Scalar',
        handles => [qw(clone copy empty_clone insert delete invert clear members elements size has contains is_null is_empty is_universal null empty universe union intersection difference symmetric_difference unique is_equal is_disjoint is_properly_intersecting is_proper_subset is_proper_superset is_subset is_superset each as_string_callback)],
        builder => '_build_set',
    );
    
    has '_pool' => (
        is => 'rw',
        isa => 'HashRef',
        default => sub{ {} },
    );
    
    
    sub insert_fruit {
        my $self = shift;
        my $type = shift;
        my $fruit = shift;
        
        if(!$self->_set->has($type)) {            
            $self->_set->insert($type);
            $self->_pool->{$type} = $fruit;
        }
    }
    
    sub has_fruit {
        my $self = shift;
        my $type = shift;
        return($self->has($type));
    }
    
    sub get_fruit {
        my $self = shift;
        my $type = shift;
        
        if ($self->has_fruit($type)) {
            return($self->_pool->{$type});
        }
    }
    
    sub all {
        my $self = shift;
        
        my @els = $self->_set->elements;
        my @buffer;
        for my $el (@els) {
            push @buffer, $el;
        }
        
        return(@buffer);
    }
    
    sub _build_set {        
        return(Set::Scalar->new());
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Fruit;
    use Moose;    
    use namespace::autoclean;
    
    has 'type' => (
        is => 'rw',
        isa => 'Str',
    );
    
    __PACKAGE__->meta->make_immutable;
}

use Data::Dumper;
    
my $la = LazyInstantiator->new();
say 'get';
say '---';
my $fruit;
$fruit = $la->get_fruit_by_type_name('Apple');
say $fruit->type;
$fruit = $la->get_fruit_by_type_name('Apple');
say $fruit->type;
$fruit = $la->get_fruit_by_type_name('Apple');
say $fruit->type;
$fruit = $la->get_fruit_by_type_name('Apple');
say $fruit->type;
$fruit = $la->get_fruit_by_type_name('Banana');
say $fruit->type;
say;
say 'exists';
say '------';
for my $fruit ($la->fruit_set->all) {
    say $fruit;
}