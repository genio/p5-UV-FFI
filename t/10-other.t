use strict;
use warnings;
use Test::More;
use UV::FFI ();

ok(UV::FFI::uv_os_uname(), "uname");
ok(UV::FFI::uv_os_gethostname(), "gethostname");
ok(UV::FFI::uv_os_homedir(), "OS homedir");
ok(UV::FFI::uv_os_tmpdir(), "OS tmpdir");

done_testing;
