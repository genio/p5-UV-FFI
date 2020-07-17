package UV::FFI::Init;

use strict;
use warnings;
use utf8;
use feature ':5.16';

use Alien::libuv;
use FFI::Platypus;

my $ffi;

unless( $ffi ) {
    $ffi = FFI::Platypus->new(api => 1);
    $ffi->lib(Alien::libuv->dynamic_libs);
    $ffi->bundle();

    # Some types differ depending on OS
    $ffi->type('int64_t', 'uv_pid_t');
    $ffi->type('int', 'uv_file');
    if ($^O eq 'MSWin32') {
        $ffi->type('opaque', 'uv_os_fd_t');
        $ffi->type('opaque', 'uv_os_sock_t');
    }
    else {
        $ffi->type('int', 'uv_os_fd_t');
        $ffi->type('int', 'uv_os_sock_t');
    }
}

# Protect subclasses using AUTOLOAD
sub DESTROY { }

sub import {
    my ($class, $caller) = (shift, caller);
    $_->import for qw(strict warnings utf8);
    feature->import(':5.16');
}

sub ffi {
    return $ffi;
}

1;
