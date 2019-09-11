package UV::FFI;

use strict;
use warnings;

use Exporter qw(import);

use Alien::libuv;
use Carp qw(croak);
use Data::Dumper::Concise qw(Dumper);
use FFI::Platypus;
use Path::Tiny qw(path);
use Sub::Util qw(set_subname);
use UV::FFI::Constants qw();

use feature ':5.10';

my $ffi = FFI::Platypus->new();
$ffi->lib(Alien::libuv->dynamic_libs);
$ffi->type('int64_t', 'uv_pid_t');
$ffi->type('int', 'uv_file');
if ($^O eq 'MSWin32') {
    $ffi->type('opaque', 'uv_os_fd_t');
    $ffi->type('opaque', 'uv_os_sock_t');
}
else {
    $ffi->type('int', 'uv_os_fd_t');
    $ffi->type('int', 'uv_os_sock_t');
}
$ffi->attach('uv_err_name' => ['int'] => 'string');
$ffi->attach('uv_strerror' => ['int'] => 'string');
$ffi->attach('uv_handle_size' => ['int'] => 'size_t');
$ffi->attach('uv_req_size' => ['int'] => 'size_t');
$ffi->attach('uv_loop_size' => [] => 'size_t');

{
    package # hide from PAUSE
        UV::TimeValT;
    use FFI::Platypus::Record;
    use Exporter qw(import);
    our @EXPORT_OK = qw(hires href);
    record_layout($ffi, qw(
        long tv_sec
        long tv_usec
    ));
    sub hires {
        my $self = shift;
        return $self->tv_sec . $self->tv_usec;
    }
    sub href {
        my $self = shift;
        my $href = {
            tv_sec => $self->tv_sec,
            tv_usec => $self->tv_usec,
        };
        return $href;
    }
    1;
}
$ffi->type('record(UV::TimeValT)' => 'uv_timeval_t');

{
    package # hide from PAUSE
        UV::TimeVal64T;
    use FFI::Platypus::Record;
    use Exporter qw(import);
    record_layout($ffi, qw(
        int64_t tv_sec
        int32_t tv_usec
    ));
    sub hires {
        my $self = shift;
        return $self->tv_sec . $self->tv_usec;
    }
    sub href {
        my $self = shift;
        my $href = {
            tv_sec => $self->tv_sec,
            tv_usec => $self->tv_usec,
        };
        return $href;
    }
    1;
}
$ffi->type('record(UV::TimeVal64T)' => 'uv_timeval64_t');

{
    package # hide from PAUSE
        UV::UTSNameT;
    use FFI::Platypus::Record;
    use Exporter qw(import);
    our @EXPORT_OK = qw(href);
    record_layout($ffi, qw(
        string(256) sysname
        string(256) release
        string(256) version
        string(256) machine
    ));
    sub href {
        my $self = shift;
        my $href = {
            sysname => $self->sysname =~ s/\0+\z//r,
            release => $self->release =~ s/\0+\z//r,
            version => $self->version =~ s/\0+\z//r,
            machine => $self->machine =~ s/\0+\z//r,
        };
        return $href;
    }
    1;
}

$ffi->type('record(UV::UTSNameT)' => 'uv_utsname_t');

{
    package # hide from PAUSE
        UV::RUsageT;
    use strict;
    use warnings;
    use UV::FFI::Constants ();
    use FFI::Platypus::Memory qw(malloc free);

    use Exporter qw(import);

    sub new {
        my $self = bless {}, shift;
        my $size_rusage = UV::FFI::Constants::UV_FFI_SIZE_RUSAGE_T;
        $self->{_ptr} = malloc($size_rusage);
        return $self;
    }

    sub DESTROY {
        my $self = shift;
        free($self->{_ptr});
    }

    sub ptr { return $_[0]->{_ptr} }

    sub href {
        my $self = shift;
        my $val = $self->ptr;
        use Data::Dumper::Concise;
        # say Dumper ${$val};
        my $size_uint64 = $ffi->sizeof('uint64_t');
        my $size_rusage = UV::FFI::Constants::UV_FFI_SIZE_RUSAGE_T;
        my $char = $ffi->sizeof('long long') == ($size_rusage/2) ? 'Q' : 'L';

        my @data = unpack("${char}4Q14", $val);
        return {
            ru_utime => {
                tv_sec => $data[0] || 0,
                tv_usec => $data[1] || 0,
            },
            ru_stime => {
                tv_sec => $data[2] || 0,
                tv_usec => $data[3] || 0,
            },
            ru_maxrss => $data[4] || 0,
            ru_ixrss => $data[5] || 0,
            ru_idrss => $data[6] || 0,
            ru_isrss => $data[7] || 0,
            ru_minflt => $data[8] || 0,
            ru_majflt => $data[9] || 0,
            ru_nswap => $data[10] || 0,
            ru_inblock => $data[11] || 0,
            ru_oublock => $data[12] || 0,
            ru_msgsnd => $data[13] || 0,
            ru_msgrcv => $data[14] || 0,
            ru_nsignals => $data[15] || 0,
            ru_nvcsw => $data[16] || 0,
            ru_nivcsw => $data[17] || 0,
        };
    }
    1;
}


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
        my $size = UV::FFI::Constants::UV_MAXHOSTNAMESIZE;
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
    # uint64_t uv_get_constrained_memory(void)
    'uv_get_constrained_memory' => {
        added => [1,29],
        ffi => [[], 'uint64_t'],
        fallback => sub {
            # uv_get_constrained_memory simply returns 0 when it doesn't know
            # what to do
            return 0;
        },
    },
    # int uv_os_homedir(char* buffer, size_t* size)
    'uv_os_homedir' => {
        added => [1,6],
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
        fallback => sub {
            # uv_os_homedir did not exist. return empty string?
            return undef;
        },
    },
    # int uv_os_tmpdir(char* buffer, size_t* size)
    'uv_os_tmpdir' => {
        added => [1,9],
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
        fallback => sub {
            # uv_os_tmpdir did not exist. return empty string?
            return undef;
        },
    },

    # uv_pid_t uv_os_getpid(void)
    'uv_os_getpid' => {
        added => [1,18],
        ffi => [ [], 'uv_pid_t' ],
        fallback => sub { return $$; },
    },

    # uv_pid_t uv_os_getppid(void)
    'uv_os_getppid' => {
        added => [1,16],
        ffi => [ [], 'uv_pid_t' ],
        fallback => sub { getppid() },
    },

    # int uv_gettimeofday(uv_timeval64_t* tv)
    'uv_gettimeofday' => {
        added => [1,28],
        ffi => [ ['uv_timeval64_t'], 'int', sub {
            my ($xsub) = @_;
            my $time_obj = UV::TimeVal64T->new(tv_sec => 0, tv_usec => 0);
            my $ret = $xsub->($time_obj);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_gettimeofday failed with: $msg");
            }
            return $time_obj;
        }],
        fallback => sub {
            warn "uv_gettimeofday not implemented until libuv v1.28";
            return UV::TimeVal64T->new(tv_sec => time, tv_usec => 0);
        },
    },

    # int uv_os_uname(uv_utsname_t* buffer)
    'uv_os_uname' => {
        added => [1,25],
        ffi => [ ['uv_utsname_t'], 'int', sub {
            my ($xsub) = @_;
            my $obj = UV::UTSNameT->new(sysname => "", release => "", version => "", machine => "");
            my $ret = $xsub->($obj);
            unless ($ret == 0) {
                my $msg = uv_err_name($ret). ': '. uv_strerror($ret);
                croak("uv_os_uname failed with: $msg");
            }
            return $obj;
        }],
        fallback => sub {
            return {};
        }
    },

    # int uv_os_getpriority(uv_pid_t pid, int* priority)
    'uv_os_getpriority' => {
        added => [1,23],
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
        fallback => sub { croak("uv_os_getpriority not implemented until v1.23"); },
    },

    # int uv_os_setpriority(uv_pid_t pid, int priority)
    'uv_os_setpriority' => {
        added => [1,23],
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
        fallback => sub { croak("uv_os_setpriority not implemented until v1.23"); },
    },

);

our @EXPORT_OK = (keys %function, keys %maybe_function);

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


    return 0 if UV::FFI::Constants::UV_VERSION_MAJOR < $maj; # full version behind of requested
    return 1 if UV::FFI::Constants::UV_VERSION_MAJOR > $maj; # full version ahead of requested
    # now we should be matching major versions
    return 1 unless $min; # if we were only given major, move on
    return 0 if UV::FFI::Constants::UV_VERSION_MINOR < $min; # same major, lower minor
    return 1 if UV::FFI::Constants::UV_VERSION_MINOR > $min; # same major, higher minor
    # now we should be matching major and minor, check patch
    return 1 unless $pat; # move on if we were given maj, min only
    return 0 if UV::FFI::Constants::UV_VERSION_PATCH < $pat;
    return 1;
}

1;
