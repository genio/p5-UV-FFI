package UV::FFI;

use UV::FFI::Init;

use Carp qw(croak);
use Data::Dumper::Concise qw(Dumper);
use Exporter qw(import);

use FFI::Platypus;
use Path::Tiny qw(path);
use Sub::Util qw(set_subname);

our @EXPORT_OK = qw(
    uv_err_name uv_handle_size uv_loop_size uv_req_size uv_strerror
    uv_os_uname
);

my $ffi = UV::FFI::Init::ffi();
$ffi->bundle();

# smaller chunks
require UV::FFI::Constants;
require UV::FFI::UTSName;
require UV::FFI::TimeVal;
require UV::FFI::TimeVal64;


# All of these functions were shipped with libuv v1.0 and don't
# need to be gated by version.
$ffi->attach('uv_err_name' => ['int'] => 'string');
$ffi->attach('uv_handle_size' => ['int'] => 'size_t');
$ffi->attach('uv_loop_size' => [] => 'size_t');
$ffi->attach('uv_req_size' => ['int'] => 'size_t');
$ffi->attach('uv_strerror' => ['int'] => 'string');
our %function = (
    # unsigned int uv_version(void)
    'uv_version' => [[] => 'unsigned int'],

    # const char* uv_version_string(void)
    'uv_version_string' => [[], 'string'],

    # uint64_t uv_hrtime(void)
    'uv_hrtime' => [[], 'uint64_t'],

    # uint64_t uv_get_free_memory(void)
    'uv_get_free_memory' => [[], 'uint64_t'],

    # uint64_t uv_get_total_memory(void)
    'uv_get_total_memory' => [[], 'uint64_t'],

    # int uv_uptime(double *)
    'uv_uptime' => [['double *'] => 'int', sub {
        my ($xsub) = @_;
        my $num = 0;
        my $ret = $xsub->(\$num);
        unless ($ret == 0) {
            my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
            croak("uv_uptime failed with: $msg");
        }
        return $num;
    }],

    # int uv_resident_set_memory(size_t* rss)
    'uv_resident_set_memory' =>[['size_t *'] => 'int', sub {
        my ($xsub) = @_;
        my $num = 0;
        my $ret = $xsub->(\$num);
        unless ($ret == 0) {
            my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
            croak("uv_resident_set_memory failed with: $msg");
        }
        return $num;
    }],

    # int uv_os_gethostname(char* buffer, size_t* size)
    'uv_os_gethostname' =>[['string', 'size_t *'] => 'int', sub {
        my ($xsub) = @_;
        my $size = UV::FFI::Constants->UV_MAXHOSTNAMESIZE;
        my $buffer = "\0"x$size;

        my $ret = $xsub->($buffer, \$size);
        unless ($ret == 0) {
            my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
            croak("uv_os_gethostname failed with: $msg");
        }
        $buffer = substr($buffer, 0, $size);
        return $buffer;
    }],

    # int uv_getrusage(uv_rusage_t* rusage)
    'uv_getrusage' => [['opaque'] => 'int', sub {
        my ($xsub) = @_;

        my $rusage = UV::RUsageT->new();
        say Dumper $rusage;
        croak("Couldn't create an RUsage") unless $rusage;
        # print "What's good", Dumper($rusage->href), "\n";
        my $ret = $xsub->($rusage->ptr);
        unless ($ret == 0) {
            my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
            croak("uv_getrusage failed with: $msg");
        }
        return $rusage->href;

    }],
);

our %maybe_function = (
    'uv_get_constrained_memory' => {
        added => [1,29],
        # uint64_t uv_get_constrained_memory(void)
        ffi => [[], 'uint64_t'],
        fallback => sub { croak("uv_get_constrained_memory not implemented until libuv v1.29"); },
    },

    'uv_gettimeofday' => {
        added => [1,28],
        # int uv_gettimeofday(uv_timeval64_t* tv)
        ffi => [ ['uv_timeval64_t'], 'int', sub {
            my ($xsub) = @_;
            my $time_obj = UV::FFI::TimeVal64->new(0,0);
            my $ret = $xsub->($time_obj);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_gettimeofday failed with: $msg");
            }
            return $time_obj;
        }],
        fallback => sub { croak("uv_gettimeofday not implemented until libuv v1.28"); },
    },

    'uv_handle_type_name' => {
        added => [1,19],
        # const char* uv_handle_type_name(uv_handle_type type)
        ffi => [ ['int'], 'string' ],
        fallback => sub { croak("uv_handle_type_name not implemented until libuv v1.19"); },
    },

    'uv_os_getpid' => {
        added => [1,18],
        # uv_pid_t uv_os_getpid(void)
        ffi => [ [], 'uv_pid_t' ],
        fallback => sub { return $$; },
    },

    'uv_os_getppid' => {
        added => [1,16],
        # uv_pid_t uv_os_getppid(void)
        ffi => [ [], 'uv_pid_t' ],
        fallback => sub { getppid() },
    },

    'uv_os_getpriority' => {
        added => [1,23],
        # int uv_os_getpriority(uv_pid_t pid, int* priority)
        ffi => [ ['uv_pid_t', 'int *'], 'int', sub {
            my ($xsub, $pid) = @_;
            croak("PID required") unless $pid;

            my $priority = 0;
            my $ret = $xsub->($pid, \$priority);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_os_getpriority failed with: $msg");
            }
            return $priority;
        }],
        fallback => sub { croak("uv_os_getpriority not implemented until libuv v1.23"); },
    },

    'uv_os_homedir' => {
        added => [1,6],
        # int uv_os_homedir(char* buffer, size_t* size)
        ffi => [['string', 'size_t *'], 'int', sub {
            my ($xsub) = @_;
            my $size = 1024; # pathmax
            my $buffer = "\0"x$size;

            my $ret = $xsub->($buffer, \$size);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_os_homedir failed with: $msg");
            }
            $buffer = substr($buffer, 0, $size);
            return $buffer;
        }],
        fallback => sub { croak("uv_os_homedir not implemented until libuv v1.6"); },
    },

    'uv_os_setpriority' => {
        added => [1,23],
        # int uv_os_setpriority(uv_pid_t pid, int priority)
        ffi => [ ['uv_pid_t', 'int'], 'int', sub {
            my ($xsub, $pid, $priority) = @_;
            croak("PID required") unless $pid;
            croak("priority required") unless defined $priority;
            my $ret = $xsub->($pid, $priority);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_os_setpriority failed with: $msg");
            }
            # just return a true value?
            return 1;
        }],
        fallback => sub { croak("uv_os_setpriority not implemented until libuv v1.23"); },
    },

    'uv_os_tmpdir' => {
        added => [1,9],
        # int uv_os_tmpdir(char* buffer, size_t* size)
        ffi => [['string', 'size_t *'], 'int', sub {
            my ($xsub) = @_;
            my $size = 1024; # pathmax
            my $buffer = "\0"x$size;

            my $ret = $xsub->($buffer, \$size);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_os_tmpdir failed with: $msg");
            }
            $buffer = substr($buffer, 0, $size);
            return $buffer;
        }],
        fallback => sub { croak("uv_os_tmpdir not implemented until libuv v1.9"); },
    },

    'uv_os_uname' => {
        added => [1,25],
        # int uv_os_uname(uv_utsname_t* buffer)
        ffi => [ ['uv_utsname_t'], 'int', sub {
            my ($xsub) = @_;
            my $obj = UV::FFI::UTSName->new('','','','');
            croak("Invalid uv_utsname_t") unless $obj;
            my $ret = $xsub->($obj);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_os_uname failed with: $msg");
            }
            # just return a true value?
            return $obj;
        }],
        fallback => sub { croak("uv_os_uname not implemented until libuv v1.25"); },
    },

    'uv_req_type_name' => {
        added => [1,19],
        # const char* uv_req_type_name(uv_req_type type)
        ffi => [ ['int'], 'string' ],
        fallback => sub { croak("uv_req_type_name not implemented until libuv v1.19"); },
    },

);

foreach my $func (keys %function) {
    $ffi->attach($func, @{$function{$func}});
}

foreach my $func (keys %maybe_function) {
    my $href = $maybe_function{$func};
    if (_version_or_better(@{$href->{added}})) {
        $ffi->attach($func, @{$href->{ffi}});
    }
    else {
        # monkey patch in the subref
        no strict 'refs';
        no warnings 'redefine';
        my $pkg = __PACKAGE__;
        *{"${pkg}::$func"} = set_subname("${pkg}::$func", $href->{fallback});
    }
}


sub _version_or_better {
    my ($maj, $min, $pat) = @_;
    $maj //= 0;
    $min //= 0;
    $pat //= 0;
    foreach my $partial ($maj, $min, $pat) {
        if ($partial =~ /[^0-9]/) {
            croak("_version_or_better requires 1 - 3 integers representing major, minor and patch numbers");
        }
    }
    # if no number was passed in, then the current version is higher
    return 1 unless ($maj || $min || $pat);


    return 0 if UV::FFI::Constants->UV_VERSION_MAJOR < $maj; # full version behind of requested
    return 1 if UV::FFI::Constants->UV_VERSION_MAJOR > $maj; # full version ahead of requested
    # now we should be matching major versions
    return 1 unless $min; # if we were only given major, move on
    return 0 if UV::FFI::Constants->UV_VERSION_MINOR < $min; # same major, lower minor
    return 1 if UV::FFI::Constants->UV_VERSION_MINOR > $min; # same major, higher minor
    # now we should be matching major and minor, check patch
    return 1 unless $pat; # move on if we were given maj, min only
    return 0 if UV::FFI::Constants->UV_VERSION_PATCH < $pat;
    return 1;
}

1;
