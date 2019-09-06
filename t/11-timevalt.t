use strict;
use warnings;
use Test::More;
use UV::FFI ();

my $timeval = UV::FFI::uv_gettimeofday();

ok($timeval, "uv_gettimeofday() returned a value");
isa_ok($timeval, 'UV::TimeVal64T', 'it is a UV::TimeVal64T');
ok($timeval->tv_sec, 'tv_sec: '. $timeval->tv_sec);
ok($timeval->tv_usec, 'tv_usec: '. $timeval->tv_usec);
ok($timeval->hires, 'hires: '. $timeval->hires);
my $answer = {
    tv_sec => $timeval->tv_sec,
    tv_usec => $timeval->tv_usec,
};
is_deeply($timeval->href, $answer, 'href: hashref representation is as expected');

done_testing;
