#include <ffi_platypus_bundle.h>
#include <stdint.h>
#include <uv.h>

/* pulled from sys/signal.h in case we don't have it in Windows */
#if !defined(SIGPROF)
#define SIGPROF 27 /* profiling time alarm */
#endif

/* added in 1.14 */
#if !defined(UV_DISCONNECT)
#define UV_DISCONNECT 4
#endif
#if !defined(UV_PRIORITIZED)
#define UV_PRIORITIZED 8
#endif
#if !defined(UV_VERSION_HEX)
#define UV_VERSION_HEX                                                         \
    ((UV_VERSION_MAJOR << 16) | (UV_VERSION_MINOR << 8) | (UV_VERSION_PATCH))
#endif

/* not added until v1.23 */
#if !defined(UV_PRIORITY_LOW)
#define UV_PRIORITY_LOW 19
#endif
#if !defined(UV_PRIORITY_LOW)
#define UV_PRIORITY_BELOW_NORMAL 10
#endif
#if !defined(UV_PRIORITY_LOW)
#define UV_PRIORITY_NORMAL 0
#endif
#if !defined(UV_PRIORITY_LOW)
#define UV_PRIORITY_ABOVE_NORMAL -7
#endif
#if !defined(UV_PRIORITY_LOW)
#define UV_PRIORITY_HIGH -14
#endif
#if !defined(UV_PRIORITY_LOW)
#define UV_PRIORITY_HIGHEST -20
#endif

/* not added until 1.24 */
#if !defined(UV_PROCESS_WINDOWS_HIDE_CONSOLE)
#define UV_PROCESS_WINDOWS_HIDE_CONSOLE (1 << 5)
#endif
#if !defined(UV_PROCESS_WINDOWS_HIDE_GUI)
#define UV_PROCESS_WINDOWS_HIDE_GUI (1 << 6)
#endif

/* not available until 1.26 */
#if !defined(UV_THREAD_NO_FLAGS)
#define UV_THREAD_NO_FLAGS 0x00
#endif
#if !defined(UV_THREAD_HAS_STACK_SIZE)
#define UV_THREAD_HAS_STACK_SIZE 0x01
#endif
#if !defined(MAXHOSTNAMELEN)
#define MAXHOSTNAMELEN 255
#endif
#if !defined(UV_MAXHOSTNAMESIZE)
#define UV_MAXHOSTNAMESIZE (MAXHOSTNAMELEN + 1)
#endif
#if !defined(UV_IF_NAMESIZE)
#if defined(IF_NAMESIZE)
#define UV_IF_NAMESIZE (IF_NAMESIZE + 1)
#elif defined(IFNAMSIZ)
#define UV_IF_NAMESIZE (IFNAMSIZ + 1)
#else
#define UV_IF_NAMESIZE (16 + 1)
#endif
#endif

#define _str(name) c->set_str(#name, name)
#define _sint(name) c->set_sint(#name, name)

void
ffi_pl_bundle_constant(const char* package, ffi_platypus_constant_t* c)
{
    /* some sizeof constants we made ourselves */
    c->set_uint("UV_FFI_SIZE_TIMEVAL_T", sizeof(uv_timeval_t));
    c->set_uint("UV_FFI_SIZE_TIMEVAL64_T", sizeof(uv_timeval64_t));
    c->set_uint("UV_FFI_SIZE_RUSAGE_T", sizeof(uv_rusage_t));

    /* version information */
    _sint(UV_VERSION_MAJOR);
    _sint(UV_VERSION_MINOR);
    _sint(UV_VERSION_PATCH);
    _sint(UV_VERSION_IS_RELEASE);
    _sint(UV_VERSION_HEX);
    _str(UV_VERSION_SUFFIX);

    /* expose the different error constants */
    _sint(UV_E2BIG);
    _sint(UV_EACCES);
    _sint(UV_EADDRINUSE);
    _sint(UV_EADDRNOTAVAIL);
    _sint(UV_EAFNOSUPPORT);
    _sint(UV_EAGAIN);
    _sint(UV_EAI_ADDRFAMILY);
    _sint(UV_EAI_AGAIN);
    _sint(UV_EAI_BADFLAGS);
    _sint(UV_EAI_BADHINTS);
    _sint(UV_EAI_CANCELED);
    _sint(UV_EAI_FAIL);
    _sint(UV_EAI_FAMILY);
    _sint(UV_EAI_MEMORY);
    _sint(UV_EAI_NODATA);
    _sint(UV_EAI_NONAME);
    _sint(UV_EAI_OVERFLOW);
    _sint(UV_EAI_PROTOCOL);
    _sint(UV_EAI_SERVICE);
    _sint(UV_EAI_SOCKTYPE);
    _sint(UV_EALREADY);
    _sint(UV_EBADF);
    _sint(UV_EBUSY);
    _sint(UV_ECANCELED);
    _sint(UV_ECHARSET);
    _sint(UV_ECONNABORTED);
    _sint(UV_ECONNREFUSED);
    _sint(UV_ECONNRESET);
    _sint(UV_EDESTADDRREQ);
    _sint(UV_EEXIST);
    _sint(UV_EFAULT);
    _sint(UV_EFBIG);
    _sint(UV_EHOSTUNREACH);
    _sint(UV_EINTR);
    _sint(UV_EINVAL);
    _sint(UV_EIO);
    _sint(UV_EISCONN);
    _sint(UV_EISDIR);
    _sint(UV_ELOOP);
    _sint(UV_EMFILE);
    _sint(UV_EMSGSIZE);
    _sint(UV_ENAMETOOLONG);
    _sint(UV_ENETDOWN);
    _sint(UV_ENETUNREACH);
    _sint(UV_ENFILE);
    _sint(UV_ENOBUFS);
    _sint(UV_ENODEV);
    _sint(UV_ENOENT);
    _sint(UV_ENOMEM);
    _sint(UV_ENONET);
    _sint(UV_ENOPROTOOPT);
    _sint(UV_ENOSPC);
    _sint(UV_ENOSYS);
    _sint(UV_ENOTCONN);
    _sint(UV_ENOTDIR);
    _sint(UV_ENOTEMPTY);
    _sint(UV_ENOTSOCK);
    _sint(UV_ENOTSUP);
    _sint(UV_EPERM);
    _sint(UV_EPIPE);
    _sint(UV_EPROTO);
    _sint(UV_EPROTONOSUPPORT);
    _sint(UV_EPROTOTYPE);
    _sint(UV_ERANGE);
    _sint(UV_EROFS);
    _sint(UV_ESHUTDOWN);
    _sint(UV_ESPIPE);
    _sint(UV_ESRCH);
    _sint(UV_ETIMEDOUT);
    _sint(UV_ETXTBSY);
    _sint(UV_EXDEV);
    _sint(UV_UNKNOWN);
    _sint(UV_EOF);
    _sint(UV_ENXIO);
    _sint(UV_EMLINK);

    /* FS Events and flags */
    _sint(UV_RENAME);
    _sint(UV_CHANGE);
    _sint(UV_FS_O_FILEMAP);
    _sint(UV_FS_O_DIRECT);
    _sint(UV_FS_O_DIRECTORY);
    _sint(UV_FS_O_DSYNC);
    _sint(UV_FS_O_EXLOCK);
    _sint(UV_FS_O_NOATIME);
    _sint(UV_FS_O_NOCTTY);
    _sint(UV_FS_O_NOFOLLOW);
    _sint(UV_FS_O_NONBLOCK);
    _sint(UV_FS_O_RANDOM);
    _sint(UV_FS_O_RDONLY);
    _sint(UV_FS_O_RDWR);
    _sint(UV_FS_O_SEQUENTIAL);
    _sint(UV_FS_O_SHORT_LIVED);
    _sint(UV_FS_O_SYMLINK);
    _sint(UV_FS_O_SYNC);
    _sint(UV_FS_O_TEMPORARY);
    _sint(UV_FS_O_TRUNC);
    _sint(UV_FS_O_WRONLY);
    _sint(UV_FS_EVENT_WATCH_ENTRY);
    _sint(UV_FS_EVENT_STAT);
    _sint(UV_FS_EVENT_RECURSIVE);
    _sint(UV_FS_COPYFILE_EXCL);
    _sint(UV_FS_COPYFILE_FICLONE);
    _sint(UV_FS_COPYFILE_FICLONE_FORCE);
    _sint(UV_FS_SYMLINK_DIR);
    _sint(UV_FS_SYMLINK_JUNCTION);
    _sint(UV_FS_UNKNOWN);
    _sint(UV_FS_CUSTOM);
    _sint(UV_FS_OPEN);
    _sint(UV_FS_CLOSE);
    _sint(UV_FS_READ);
    _sint(UV_FS_WRITE);
    _sint(UV_FS_SENDFILE);
    _sint(UV_FS_STAT);
    _sint(UV_FS_LSTAT);
    _sint(UV_FS_FSTAT);
    _sint(UV_FS_FTRUNCATE);
    _sint(UV_FS_UTIME);
    _sint(UV_FS_FUTIME);
    _sint(UV_FS_ACCESS);
    _sint(UV_FS_CHMOD);
    _sint(UV_FS_FCHMOD);
    _sint(UV_FS_FSYNC);
    _sint(UV_FS_FDATASYNC);
    _sint(UV_FS_UNLINK);
    _sint(UV_FS_RMDIR);
    _sint(UV_FS_MKDIR);
    _sint(UV_FS_MKDTEMP);
    _sint(UV_FS_RENAME);
    _sint(UV_FS_SCANDIR);
    _sint(UV_FS_LINK);
    _sint(UV_FS_SYMLINK);
    _sint(UV_FS_READLINK);
    _sint(UV_FS_CHOWN);
    _sint(UV_FS_FCHOWN);
    _sint(UV_FS_REALPATH);
    _sint(UV_FS_COPYFILE);
    _sint(UV_FS_LCHOWN);
    _sint(UV_FS_OPENDIR);
    _sint(UV_FS_READDIR);
    _sint(UV_FS_CLOSEDIR);
    _sint(UV_DIRENT_UNKNOWN);
    _sint(UV_DIRENT_FILE);
    _sint(UV_DIRENT_DIR);
    _sint(UV_DIRENT_LINK);
    _sint(UV_DIRENT_FIFO);
    _sint(UV_DIRENT_SOCKET);
    _sint(UV_DIRENT_CHAR);
    _sint(UV_DIRENT_BLOCK);

    /* expose the different Handle constants */
    _sint(UV_UNKNOWN_HANDLE);
    _sint(UV_ASYNC);
    _sint(UV_CHECK);
    _sint(UV_FS_EVENT);
    _sint(UV_FS_POLL);
    _sint(UV_HANDLE);
    _sint(UV_IDLE);
    _sint(UV_NAMED_PIPE);
    _sint(UV_POLL);
    _sint(UV_PREPARE);
    _sint(UV_PROCESS);
    _sint(UV_STREAM);
    _sint(UV_TCP);
    _sint(UV_TIMER);
    _sint(UV_TTY);
    _sint(UV_UDP);
    _sint(UV_SIGNAL);
    _sint(UV_FILE);
    _sint(UV_HANDLE_TYPE_MAX);

    /* expose the different Request constants */
    _sint(UV_UNKNOWN_REQ);
    _sint(UV_REQ);
    _sint(UV_CONNECT);
    _sint(UV_WRITE);
    _sint(UV_SHUTDOWN);
    _sint(UV_UDP_SEND);
    _sint(UV_FS);
    _sint(UV_WORK);
    _sint(UV_GETADDRINFO);
    _sint(UV_GETNAMEINFO);
    _sint(UV_REQ_TYPE_MAX);

    /* Loop run constants */
    _sint(UV_RUN_DEFAULT);
    _sint(UV_RUN_ONCE);
    _sint(UV_RUN_NOWAIT);

    /* expose the Loop configure constants */
    _sint(UV_LOOP_BLOCK_SIGNAL);
    _sint(SIGPROF);

    /* Poll Event Types */
    _sint(UV_READABLE);
    _sint(UV_WRITABLE);
    _sint(UV_DISCONNECT);
    _sint(UV_PRIORITIZED);

    /* Priority Constants */
    _sint(UV_PRIORITY_LOW);
    _sint(UV_PRIORITY_BELOW_NORMAL);
    _sint(UV_PRIORITY_NORMAL);
    _sint(UV_PRIORITY_ABOVE_NORMAL);
    _sint(UV_PRIORITY_HIGH);
    _sint(UV_PRIORITY_HIGHEST);

    /* Process Constants */
    _sint(UV_PROCESS_SETUID);
    _sint(UV_PROCESS_SETGID);
    _sint(UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS);
    _sint(UV_PROCESS_DETACHED);
    _sint(UV_PROCESS_WINDOWS_HIDE);
    _sint(UV_PROCESS_WINDOWS_HIDE_CONSOLE);
    _sint(UV_PROCESS_WINDOWS_HIDE_GUI);

    /* Process STDIO flags */
    _sint(UV_IGNORE);
    _sint(UV_CREATE_PIPE);
    _sint(UV_INHERIT_FD);
    _sint(UV_INHERIT_STREAM);
    _sint(UV_READABLE_PIPE);
    _sint(UV_WRITABLE_PIPE);
    _sint(UV_OVERLAPPED_PIPE);

    /* max string buffer */
    _sint(UV_MAXHOSTNAMESIZE);
    _sint(UV_IF_NAMESIZE);

    /* Threads */
    _sint(UV_THREAD_NO_FLAGS);
    _sint(UV_THREAD_HAS_STACK_SIZE);

    /* TTY Modes */
    _sint(UV_TTY_MODE_NORMAL);
    _sint(UV_TTY_MODE_RAW);
    _sint(UV_TTY_MODE_IO);

    /* UDP flags and Modes */
    _sint(UV_UDP_IPV6ONLY);
    _sint(UV_UDP_PARTIAL);
    _sint(UV_UDP_REUSEADDR);
    _sint(UV_LEAVE_GROUP);
    _sint(UV_JOIN_GROUP);
}
