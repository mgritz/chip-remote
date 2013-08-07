#ifndef INC_UTILS_H
#define INC_UTILS_H

#include <stdint.h>
#include <string.h>

#define STREQ(x, y) (!strcmp(x, y))
#define STREQ_N(x, y, n) (!strncmp(x, y, n))
#define _(x) ((const char *)x)

uint32_t str2uint(const char *, int *);
void uint2str(uint32_t, char *);

#endif /* INC_UTILS_H */
