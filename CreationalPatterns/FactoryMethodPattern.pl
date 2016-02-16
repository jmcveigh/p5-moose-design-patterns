#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package PeopleRole;
    use Moose::Role;
    
    requires 'Location';
}

{
    package RuralPeople;
    use Moose;
    with 'PeopleRole';
    use namespace::autoclean;
    
    sub Location {
        return("Uptergrove, ON, CA");
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package TownPeople;
    use Moose;
    with 'PeopleRole';
    use namespace::autoclean;
    
    sub Location {
        return("Orillia, ON, CA");
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package UrbanPeople;
    use Moose;
    with 'PeopleRole';
    use namespace::autoclean;
    
    sub Location {
        return("Barrie, ON, CA");
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Factory;
    use Moose;
    use Moose::Util::TypeConstraints;
    use namespace::autoclean;
    
    enum 'PeopleType', [qw(rural town urban)];
    
    sub GetPeople {
        my $self = shift;
        my $people_type = shift;
        my $people;
        
        given($people_type) {
            when(/rural/) {
                $people = RuralPeople->new();
            }
            
            when(/town/) {
                $people = TownPeople->new();
            }
            
            when(/urban/) {
                $people = UrbanPeople->new();
            }
        }
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $factory = Factory->new();
my $people = $factory->GetPeople('rural');
say $people->Location();