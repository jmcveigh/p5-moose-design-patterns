use 5.022;
use threads;
use threads::shared;

my $localvar;
my $sharedvar :shared;