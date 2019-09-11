use strict;
use warnings;
use Test::More;
use UV::FFI ();
use UV::FFI::Constants ();

# check out the various error constants
my @errors = qw(
    UV_E2BIG UV_EACCES UV_EADDRINUSE UV_EADDRNOTAVAIL UV_EAFNOSUPPORT
    UV_EAGAIN UV_EAI_ADDRFAMILY UV_EAI_AGAIN UV_EAI_BADFLAGS UV_EAI_BADHINTS
    UV_EAI_CANCELED UV_EAI_FAIL UV_EAI_FAMILY UV_EAI_MEMORY UV_EAI_NODATA
    UV_EAI_NONAME UV_EAI_OVERFLOW UV_EAI_PROTOCOL UV_EAI_SERVICE
    UV_EAI_SOCKTYPE UV_EALREADY UV_EBADF UV_EBUSY UV_ECANCELED
    UV_ECHARSET UV_ECONNABORTED UV_ECONNREFUSED UV_ECONNRESET
    UV_EDESTADDRREQ UV_EEXIST UV_EFAULT UV_EFBIG UV_EHOSTUNREACH
    UV_EINTR UV_EINVAL UV_EIO UV_EISCONN UV_EISDIR UV_ELOOP
    UV_EMFILE UV_EMSGSIZE UV_ENAMETOOLONG UV_ENETDOWN UV_ENETUNREACH
    UV_ENFILE UV_ENOBUFS UV_ENODEV UV_ENOENT UV_ENOMEM UV_ENONET
    UV_ENOPROTOOPT UV_ENOSPC UV_ENOSYS UV_ENOTCONN UV_ENOTDIR
    UV_ENOTEMPTY UV_ENOTSOCK UV_ENOTSUP UV_EPERM UV_EPIPE UV_EPROTO
    UV_EPROTONOSUPPORT UV_EPROTOTYPE UV_ERANGE UV_EROFS UV_ESHUTDOWN
    UV_ESPIPE UV_ESRCH UV_ETIMEDOUT UV_ETXTBSY UV_EXDEV UV_UNKNOWN
    UV_EOF UV_ENXIO UV_EMLINK
);

foreach my $err (@errors) {
    my $err_int = UV::FFI::Constants->$err;
    my $err_str = UV::FFI::uv_strerror($err_int);
    ok($err_str, "uv_strerror($err): $err_str");
}

foreach my $err (@errors) {
    my $err_int = UV::FFI::Constants->$err;
    my $err_str = UV::FFI::uv_err_name($err_int);
    my $err_expected = $err =~ s/^UV_//r;
    is($err_str, $err_expected, "uv_err_name($err): $err_str");
}

done_testing;