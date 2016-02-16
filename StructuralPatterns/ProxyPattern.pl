#!/opt/ActivePerl-5.22/bin/perl
use 5.022;

{
    package Image;
    use Moose::Role;
    
    requires 'display_image';
}

{
    package RealImage;
    use Moose;
    with 'Image';
    use namespace::autoclean;
    
    has 'filename' => (
        is => 'rw',
        isa => 'Str'
    );
    
    sub BUILD {
        my $self = shift;
        $self->load_image_from_disk;
    }
    
    sub load_image_from_disk {
        my $self = shift;
        say "Loading " . $self->filename;
    }
    
    sub display_image {
        my $self = shift;
        say "Displaying " . $self->filename;
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package ProxyImage;
    use Moose;
    with 'Image';
    use namespace::autoclean;
    
    has 'image' => (
        is => 'rw',
        isa => 'RealImage',        
    );
    
    has 'filename' => (
        is => 'rw',
        isa => 'Str',
    );    
    
    sub display_image {
        my $self = shift;
        if (!$self->image) {
            $self->image = RealImage->new();
        }
        
        $self->image->display_image();
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package Application;
    use Moose;
    use namespace::autoclean;
    
    for my $name (qw(image1 image2)) {
        has $name => (
            is => 'rw',
            isa => 'RealImage',
            default => sub { RealImage->new(filename => $name); },
        );
    }
    
    sub main {
        my $self = shift;
        
        $self->image1->display_image();
        $self->image1->display_image();
        $self->image2->display_image();
        $self->image2->display_image();        
        $self->image1->display_image();        
    }
        
    __PACKAGE__->meta->make_immutable;
}

my $app = Application->new();
$app->main();