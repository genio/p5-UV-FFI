use strict;
use warnings;
use Test::More;
use UV::FFI ();

my $utsname = UV::FFI::uv_os_uname();

ok($utsname, "uv_os_uname() returned a value");
isa_ok($utsname, 'UV::UTSNameT', 'it is a UV::UTSNameT');
ok($utsname->sysname, 'sysname: '. $utsname->sysname =~ s/\0+\z//r);
ok($utsname->release, 'release: '. $utsname->release =~ s/\0+\z//r);
ok($utsname->version, 'version: '. $utsname->version =~ s/\0+\z//r);
ok($utsname->machine, 'machine: '. $utsname->machine =~ s/\0+\z//r);
my $answer = {
    sysname => $utsname->sysname =~ s/\0+\z//r,
    release => $utsname->release =~ s/\0+\z//r,
    version => $utsname->version =~ s/\0+\z//r,
    machine => $utsname->machine =~ s/\0+\z//r,
};
is_deeply($utsname->href, $answer, 'href: hashref representation is as expected');

done_testing;
