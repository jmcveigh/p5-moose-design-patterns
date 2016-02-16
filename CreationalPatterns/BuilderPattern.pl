#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Point;
    use Moose;
    use namespace::autoclean;
    
    for my $name (qw(lat long)){
        has $name => (
            is => 'rw',
            isa => 'Num',            
        );
    };
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Colour;
    use Moose;
    use namespace::autoclean;
    
    for my $name (qw(r g b)) {
        has $name => (
            is => 'rw',
            isa => 'Int'
        );
    };
    
    __PACKAGE__->meta->make_immutable;
}

{
    package StreetMap;
    use Moose;
    use namespace::autoclean;
    
    for my $name (qw(_origin _destination)) {
        my $builder = '_build' . $name;
        has $name => (
            is => 'ro',
            isa => 'Point',
            builder => $builder,
        );
    }
    
    for my $name (qw(_water_colour _land_colour _high_traffic_colour _medium_traffic_colour _low_traffic_colour)) {
        my $builder = '_build' . $name;
        has $name => (
            is => 'ro',
            isa => 'Colour',
            builder => $builder,
        );
    }
    
    sub say {
        my $self = shift;
        say "lat: " .  $self->_origin->lat . " ,long: " . $self->_origin->long . " is rgba(0," . $self->_low_traffic_colour->g . ",0,0);";
    }
        
    sub _build_origin {
        return(Point->new(lat => 0.500,long => 0.500));
    }
    
    sub _build_destination {
        return(Point->new(lat => 0.250,long => 0.250));
    }
    
    sub _build_water_colour {
        return(Colour->new(b => 255));
    }
    
    sub _build_high_traffic_colour {
        return(Colour->new(r => 255));
    }
    
    sub _build_low_traffic_colour {
        return(Colour->new(g => 255, r => 0, b => 0, a => 0));
    }
    
    sub _build_land_colour {
        return(Colour->new(r => 30,g => 30,b => 30, a => 255));
    }
    
    sub _build_medium_traffic_colour {
        return(Colour->new(r => 255,g => 255,b => 0, a => 255));
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $sm = StreetMap->new();
$sm->say();