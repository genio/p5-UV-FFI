use strict;
use warnings;
use Test::More;
use UV::FFI ();
use UV::FFI::Constants ();

ok(defined UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL_T, "sizeof(UV_FFI_SIZE_TIMEVAL_T): ". UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL_T);
ok(defined UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL64_T, "sizeof(UV_FFI_SIZE_TIMEVAL64_T): ". UV::FFI::Constants::UV_FFI_SIZE_TIMEVAL64_T);
ok(defined UV::FFI::Constants::UV_FFI_SIZE_RUSAGE_T, "sizeof(UV_FFI_SIZE_RUSAGE_T): ". UV::FFI::Constants::UV_FFI_SIZE_RUSAGE_T);
ok(defined UV::FFI::uv_loop_size, "uv_loop_size: ". UV::FFI::uv_loop_size);
ok(defined UV::FFI::uv_handle_size, "uv_handle_size: ". UV::FFI::uv_handle_size);

done_testing;
