#include <ffi_platypus_bundle.h>
#include <stdint.h>

#include <uv.h>

/*
This is how libuv defines it

typedef struct
{
    long tv_sec;
    long tv_usec;
} uv_timeval_t;
*/

uv_timeval_t*
timeval__new(const char* class_name, long sec, long usec)
{
    (void)class_name;
    if (sec == NULL)
        sec = 0;
    if (usec == NULL)
        usec = 0;
    uv_timeval_t* self = malloc(sizeof(uv_timeval_t));
    self->tv_sec = sec;
    self->tv_usec = usec;
    return self;
}

long
timeval__tv_sec(uv_timeval_t* self)
{
    return self->tv_sec;
}

long
timeval__tv_usec(uv_timeval_t* self)
{
    return self->tv_usec;
}

void
timeval__DESTROY(uv_timeval_t* self)
{
    free(self);
}
/*
This is how libuv defines it

typedef struct {
    int64_t tv_sec;
    int32_t tv_usec;
} uv_timeval64_t;
*/

uv_timeval64_t*
timeval64__new(const char* class_name, int64_t sec, int32_t usec)
{
    (void)class_name;
    if (sec == NULL)
        sec = 0;
    if (usec == NULL)
        usec = 0;
    uv_timeval64_t* self = malloc(sizeof(uv_timeval64_t));
    self->tv_sec = sec;
    self->tv_usec = usec;
    return self;
}

int64_t
timeval64__tv_sec(uv_timeval64_t* self)
{
    return self->tv_sec;
}

int32_t
timeval64__tv_usec(uv_timeval64_t* self)
{
    return self->tv_usec;
}

void
timeval64__DESTROY(uv_timeval64_t* self)
{
    free(self);
}
