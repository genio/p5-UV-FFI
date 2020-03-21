#include "p5uv.h"

/*
This is how libuv defines it

typedef struct uv_utsname_s
{
    char sysname[256];
    char release[256];
    char version[256];
    char machine[256];
} uv_utsname_t;
*/

uv_utsname_t*
utsname__new(const char* class_name,
             const char* sysname,
             const char* release,
             const char* version,
             const char* machine)
{
    (void)class_name;
    uv_utsname_t* self = malloc(sizeof(uv_utsname_t));
    if (strlcpy(self->sysname, sysname, 255) > 255) {
        strlcpy(self->sysname, 'ERROR - too long', 255);
    }
    if (strlcpy(self->release, release, 255) > 255) {
        strlcpy(self->release, 'ERROR - too long', 255);
    }
    if (strlcpy(self->version, version, 255) > 255) {
        strlcpy(self->version, 'ERROR - too long', 255);
    }
    if (strlcpy(self->machine, machine, 255) > 255) {
        strlcpy(self->machine, 'ERROR - too long', 255);
    }
    return self;
}

const char*
utsname__sysname(uv_utsname_t* self)
{
    return self->sysname;
}

const char*
utsname__release(uv_utsname_t* self)
{
    return self->release;
}

const char*
utsname__version(uv_utsname_t* self)
{
    return self->version;
}

const char*
utsname__machine(uv_utsname_t* self)
{
    return self->machine;
}

void
utsname__DESTROY(uv_utsname_t* self)
{
    free(self);
}
