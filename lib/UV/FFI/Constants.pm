package UV::FFI::Constants;

use UV::FFI::Init;
use FFI::Platypus;
# use v5.16;
# use Exporter qw(import);

my $ffi = UV::FFI::Init::ffi();
$ffi->bundle();
# say "haha'";
# $foo = 'bar';
# our @EXPORT_OK = (
#     @UV::FFI::Constants::EXPORT_OK,
#     grep(sub {$_ && $_ =~ /^UV_/}, %UV::FFI::Constants::),
# );

1;
