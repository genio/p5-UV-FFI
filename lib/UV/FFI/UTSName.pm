package UV::FFI::UTSName;

use strict;
use warnings;
use Exporter qw(import);

use FFI::Platypus;

{
  my $ffi = FFI::Platypus->new( api => 1 );

  $ffi->type('object(UV::FFI::UTSName)' => 'uv_utsname_t');
  $ffi->bundle();

  $ffi->attach([utsname__new => 'new'] => [ 'string', 'string', 'string', 'string', 'string' ] => 'uv_utsname_t');
  $ffi->attach([utsname__sysname => 'sysname'] => ['uv_utsname_t'] => 'string');
  $ffi->attach([utsname__release => 'release'] => ['uv_utsname_t'] => 'string');
  $ffi->attach([utsname__version => 'version'] => ['uv_utsname_t'] => 'string');
  $ffi->attach([utsname__machine => 'machine'] => ['uv_utsname_t'] => 'string');
  $ffi->attach([utsname__DESTROY => 'DESTROY'] => ['uv_utsname_t'] => 'void');
}

sub href {
    my $self = shift;
    return +{
        sysname => $self->sysname,
        release => $self->release,
        version => $self->version,
        machine => $self->machine,
    };
}

1;
