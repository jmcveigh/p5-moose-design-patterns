use 5.020;

my $idx = 0x01;

{
    package ExpensiveObject;
    use Moose;
    use namespace::autoclean;
    use Time::HiRes qw(time);

    has 'idx' => (
        is => 'rw',
        isa => 'Int',
        default => sub { $idx++; },
    );

    has 'created_at' => (
        is => 'rw',
        default => sub { time },
    );

    __PACKAGE__->meta->make_immutable;
}

{
    package Pool;
    use Moose;
    use namespace::autoclean;
    use Data::Dumper;
   
    has '_available' => (
        is => 'rw',
        isa => 'ArrayRef',
        default => sub { [] },
    );

    has '_in_use' => (
        is => 'rw',
        isa => 'ArrayRef',
        default => sub { [] },
    );

    sub get_object {
        my $self = shift;
        
        if(scalar(@{$self->_available}) > 0) {
            my $po = pop(@{$self->_available});
            push(@{$self->_in_use},$po);
            return($po);
        } else {        
            my $po = ExpensiveObject->new;
            push @{$self->_in_use},$po;
            return($po);
        }    
    }

    sub release_object {
        my $self = shift;
        my $po = shift;
        my @lst_temp = [];
        push @{$self->_available},$po;
        for my $co (@{$self->_in_use}) {
            push @lst_temp, $co unless $co->idx == $po->idx;
        }
        $self->_in_use(\@lst_temp);
    }

    __PACKAGE__->meta->make_immutable;
}

use POSIX qw(strftime);

sub saytime {
    my $obj = shift;
    say $obj->created_at;
}

my $pool = Pool->new;
my $obj1 = $pool->get_object;
saytime($obj1);
my $obj2 = $pool->get_object;
saytime($obj2);
$pool->release_object($obj2);
my $obj3 = $pool->get_object;
saytime($obj3);
