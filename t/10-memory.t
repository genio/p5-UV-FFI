use strict;
use warnings;
use Test::More;
use UV::FFI ();

ok(UV::FFI::uv_get_free_memory(), 'has free memory');
ok(UV::FFI::uv_get_total_memory(), 'has total memory');
ok(UV::FFI::uv_resident_set_memory(), 'has resident set memory');
ok(UV::FFI::uv_get_constrained_memory(), 'has constrained memory');

done_testing;
