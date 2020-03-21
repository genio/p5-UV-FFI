use strict;
use warnings;
use Test::More;
use UV::FFI ();

use UV::FFI::TimeVal64 ();
use UV::FFI::TimeVal ();

{
    my $tv = UV::FFI::TimeVal->new(1,1);
    isa_ok($tv, 'UV::FFI::TimeVal', 'It is a UV::FFI::TimeVal');
    is($tv->tv_sec, 1, 'TV - tv_sec: 1');
    is($tv->tv_usec, 1, 'TV - tv_usec: 1');
    is_deeply($tv->href, {tv_sec => 1, tv_usec => 1}, 'TV - href: got right answer');
    is($tv->hires, 11, 'TV - hires: 11');
}
{
    my $tv = UV::FFI::TimeVal64->new(1,1);
    isa_ok($tv, 'UV::FFI::TimeVal64', 'It is a UV::FFI::TimeVal64');
    is($tv->tv_sec, 1, 'TV64 - tv_sec: 1');
    is($tv->tv_usec, 1, 'TV64 - tv_usec: 1');
    is_deeply($tv->href, {tv_sec => 1, tv_usec => 1}, 'TV64 - href: got right answer');
    is($tv->hires, 11, 'TV64 - hires: 11');
}

# this could return a TimeVal or TimeVal64
my $timeval = UV::FFI::uv_gettimeofday();
ok($timeval, "uv_gettimeofday() returned a value");
ok($timeval->tv_sec, 'tv_sec: '. $timeval->tv_sec);
ok($timeval->tv_usec, 'tv_usec: '. $timeval->tv_usec);
ok($timeval->hires, 'hires: '. $timeval->hires);
my $answer = {
    tv_sec => $timeval->tv_sec,
    tv_usec => $timeval->tv_usec,
};
is_deeply($timeval->href, $answer, 'href: hashref representation is as expected');

done_testing;
