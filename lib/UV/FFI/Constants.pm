package UV::FFI::Constants;

use strict;
use warnings;

use Exporter qw(import);
use FFI::Platypus;

{
    my $ffi = FFI::Platypus->new(api => 1);
    $ffi->bundle();
}

1;
