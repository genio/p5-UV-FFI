use strict;
use warnings;
use Test::More;
use UV::FFI ();
use UV::FFI::Constants ();

ok(defined UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL_T, "sizeof(UV_FFI_SIZE_TIMEVAL_T): ". UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL_T);
ok(defined UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL64_T, "sizeof(UV_FFI_SIZE_TIMEVAL64_T): ". UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL64_T);
ok(defined UV::FFI::Constants::UV_FFI_SIZE_RUSAGE_T, "sizeof(UV_FFI_SIZE_RUSAGE_T): ". UV::FFI::Constants::UV_FFI_SIZE_RUSAGE_T);
ok(defined UV::FFI::uv_loop_size, "uv_loop_size: ". UV::FFI::uv_loop_size);

# check out the various handle sizes
my @types = qw(
    UV_UNKNOWN_HANDLE UV_ASYNC UV_CHECK UV_FS_EVENT UV_FS_POLL
    UV_HANDLE UV_IDLE UV_NAMED_PIPE UV_POLL
    UV_PREPARE UV_PROCESS UV_STREAM UV_TCP
    UV_TIMER UV_TTY UV_UDP UV_SIGNAL
    UV_FILE UV_HANDLE_TYPE_MAX
);

foreach my $type (@types) {
    my $handle = UV::FFI::Constants->$type;
    my $size = UV::FFI::uv_handle_size($handle);
    ok($size, "uv_handle_size($type): $size");
}

@types = qw(
    UV_UNKNOWN_REQ UV_REQ UV_CONNECT UV_WRITE
    UV_SHUTDOWN UV_UDP_SEND UV_FS UV_WORK
    UV_GETADDRINFO UV_GETNAMEINFO UV_REQ_TYPE_MAX
);

foreach my $type (@types) {
    my $req = UV::FFI::Constants->$type;
    my $size = UV::FFI::uv_req_size($req);
    ok($size, "uv_req_size($type): $size");
}

done_testing;
