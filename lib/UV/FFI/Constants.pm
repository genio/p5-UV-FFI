package UV::FFI::Constants;

use strict;
use warnings;

use Exporter qw(import);
use FFI::Platypus;

BEGIN {
    my $ffi = FFI::Platypus->new(api => 1, experimental => 1);
    $ffi->bundle;

    our @EXPORT_OK;
    foreach my $name (keys %UV::FFI::Constants::) {
        next unless $name =~ /^UV_/;
        push @EXPORT_OK, $name;
    }
}

1;
