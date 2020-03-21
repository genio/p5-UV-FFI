use strict;
use warnings;
use Test::More;

use v5.10;
use Data::Dumper::Concise;
use UV::FFI ();

my $utsname = UV::FFI::uv_os_uname();

ok($utsname, "uv_os_uname() returned a value");
isa_ok($utsname, 'UV::FFI::UTSName', 'it is a UV::FFI::UTSName');
ok($utsname->sysname, 'sysname: '. $utsname->sysname);
ok($utsname->release, 'release: '. $utsname->release);
ok($utsname->version, 'version: '. $utsname->version);
ok($utsname->machine, 'machine: '. $utsname->machine);
my $answer = +{
    sysname => $utsname->sysname,
    release => $utsname->release,
    version => $utsname->version,
    machine => $utsname->machine,
};
is_deeply($utsname->href, $answer, 'href: hashref representation is as expected');

done_testing;
