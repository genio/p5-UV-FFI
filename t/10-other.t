use strict;
use warnings;
use Test::More;
use UV::FFI ();
use UV::FFI::Constants ();

ok(UV::FFI::uv_os_uname(), "uname");
ok(UV::FFI::uv_os_gethostname(), "gethostname");
ok(UV::FFI::uv_os_homedir(), "OS homedir");
ok(UV::FFI::uv_os_tmpdir(), "OS tmpdir");

# Test that uv_req_type_name gives the proper response for each type
my @types = qw(
    UV_REQ UV_CONNECT UV_WRITE
    UV_SHUTDOWN UV_UDP_SEND UV_FS UV_WORK
    UV_GETADDRINFO UV_GETNAMEINFO
);

foreach my $type (@types) {
    my $req = UV::FFI::Constants->$type;
    my $type_str = UV::FFI::uv_req_type_name($req);
    ok($type_str, "uv_req_type_name($type): $type_str");
}

# Test that uv_handle_type_name gives the proper response for each type
@types = qw(
    UV_ASYNC UV_CHECK UV_FS_EVENT UV_FS_POLL
    UV_HANDLE UV_IDLE UV_NAMED_PIPE UV_POLL
    UV_PREPARE UV_PROCESS UV_STREAM UV_TCP
    UV_TIMER UV_TTY UV_UDP UV_SIGNAL
    UV_FILE
);

foreach my $type (@types) {
    my $req = UV::FFI::Constants->$type;
    my $type_str = UV::FFI::uv_handle_type_name($req);
    ok($type_str, "uv_handle_type_name($type): $type_str");
}

done_testing;
