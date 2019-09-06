use strict;
use warnings;
use Test::More;
use UV::FFI ();
use UV::FFI::Constants ();

ok(UV::FFI::uv_version(), "version");
ok(UV::FFI::uv_version_string(), "version string");
ok(defined UV::FFI::Constants::UV_VERSION_MAJOR, "VERSION MAJOR: ". UV::FFI::Constants::UV_VERSION_MAJOR);
ok(defined UV::FFI::Constants::UV_VERSION_MINOR, "VERSION MINOR: ". UV::FFI::Constants::UV_VERSION_MINOR);
ok(defined UV::FFI::Constants::UV_VERSION_PATCH, "VERSION PATCH: ". UV::FFI::Constants::UV_VERSION_PATCH);
ok(defined UV::FFI::Constants::UV_VERSION_HEX, "VERSION HEX: ". UV::FFI::Constants::UV_VERSION_HEX);
ok(defined UV::FFI::Constants::UV_VERSION_SUFFIX, "VERSION SUFFIX: ". UV::FFI::Constants::UV_VERSION_SUFFIX);
ok(defined UV::FFI::Constants::UV_VERSION_IS_RELEASE, "VERSION IS RELEASE: ". UV::FFI::Constants::UV_VERSION_IS_RELEASE);

done_testing;
