use strict;
use warnings;
use Test::More;
use UV::FFI ();
use UV::FFI::Constants ();

my $uv_pid = UV::FFI::uv_os_getpid();
my $uv_ppid = UV::FFI::uv_os_getppid();
my $priority = UV::FFI::uv_os_getpriority($uv_pid);
my $perl_pid = $$;

ok($uv_pid, "PID UV: $uv_pid, Perl: $perl_pid");
ok($uv_pid, "PPID UV: $uv_ppid, Perl: $perl_pid");
ok(defined($priority), "Process Priority is $priority for $uv_pid");
is(UV::FFI::uv_os_setpriority($uv_pid, UV::FFI::Constants::UV_PRIORITY_LOW), 1, "Set priority to low for $uv_pid");
my $new_priority = UV::FFI::uv_os_getpriority($uv_pid);
is($new_priority, UV::FFI::Constants::UV_PRIORITY_LOW, "Process Priority for $uv_pid is now $new_priority");

done_testing;
