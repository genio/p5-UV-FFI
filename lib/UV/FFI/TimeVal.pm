package UV::FFI::TimeVal;

use UV::FFI::Init;
use Exporter qw(import);

{
    my $ffi = UV::FFI::Init::ffi();

    $ffi->type('object(UV::FFI::TimeVal)' => 'uv_timeval_t');

    $ffi->attach([timeval64__new => 'new'] => [ 'string', 'long', 'long' ] => 'uv_timeval_t');
    $ffi->attach([timeval64__tv_sec => 'tv_sec'] => ['uv_timeval_t'] => 'long');
    $ffi->attach([timeval64__tv_usec => 'tv_usec'] => ['uv_timeval_t'] => 'long');
    $ffi->attach([timeval64__DESTROY => 'DESTROY'] => ['uv_timeval_t'] => 'void');
}

sub hires {
    my $self = shift;
    return $self->tv_sec . $self->tv_usec;
}

sub href {
    my $self = shift;
    return +{
        tv_sec => $self->tv_sec,
        tv_usec => $self->tv_usec,
    };
}

1;
