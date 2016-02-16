use 5.022;

{
    package Animal;
    use Moose::Role;

    requires qw(sound);
}

{
    package Dog;
    use Moose;
    with 'Animal';
    use namespace::autoclean;

    sub sound {
       say "Woof!";
    }
    
    __PACKAGE__->meta->make_immutable;
}

{
    package NullAnimal;
    use Moose;
    with 'Animal';
    use namespace::autoclean;

    sub sound {
        return;
    }
    
    __PACKAGE__->meta->make_immutable;
}
