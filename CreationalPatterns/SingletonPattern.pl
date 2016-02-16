#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Singleton;
    use Moose;
    use namespace::autoclean;
    
    our $_instance = Singleton->new();
    sub get_instance {
        return($_instance);
    }
    
    sub action {
        say "Say, Hello!";
    }
    
    __PACKAGE__->meta->make_immutable;
}

my $current_instance_of_singleton = Singleton->get_instance;
$current_instance_of_singleton->action;