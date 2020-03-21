#ifndef p5uv_H
#define p5uv_H

#include <ffi_platypus_bundle.h>
#include <string.h>
#include <stdint.h>

#include <uv.h>

extern size_t
strlcpy(char* dest, const char* source, size_t size);

extern uv_utsname_t*
utsname__new(const char* class_name,
             const char* sysname,
             const char* release,
             const char* version,
             const char* machine);

extern const char*
utsname__sysname(uv_utsname_t* self);

extern const char*
utsname__release(uv_utsname_t* self);

extern const char*
utsname__version(uv_utsname_t* self);

extern const char*
utsname__machine(uv_utsname_t* self);

extern void
utsname__DESTROY(uv_utsname_t* self);

size_t
strlcpy(char* dest, const char* source, size_t size)
{
    size_t src_size = 0;
    size_t n = size;

    if (n)
        while (--n && (*dest++ = *source++))
            src_size++;

    if (!n) {
        if (size)
            *dest = '\0';
        while (*source++)
            src_size++;
    }

    return src_size;
}

#endif
