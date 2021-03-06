package UV::FFI::TimeVal64;

use UV::FFI::Init;
use Exporter qw(import);

{
    my $ffi = UV::FFI::Init::ffi();

    $ffi->type('object(UV::FFI::TimeVal64)' => 'uv_timeval64_t');

    $ffi->attach([timeval64__new => 'new'] => [ 'string', 'int64_t', 'int32_t' ] => 'uv_timeval64_t');
    $ffi->attach([timeval64__tv_sec => 'tv_sec'] => ['uv_timeval64_t'] => 'int64_t');
    $ffi->attach([timeval64__tv_usec => 'tv_usec'] => ['uv_timeval64_t'] => 'int32_t');
    $ffi->attach([timeval64__DESTROY => 'DESTROY'] => ['uv_timeval64_t'] => 'void');
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
