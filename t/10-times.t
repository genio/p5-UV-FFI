use strict;
use warnings;
use Test::More;
use UV::FFI ();

ok(UV::FFI::uv_hrtime(), "Hi-Res time");
ok(UV::FFI::uv_uptime(), "Uptime");
ok(UV::FFI::uv_gettimeofday(), "Get time of day");

done_testing;
