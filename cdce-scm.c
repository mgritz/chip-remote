/*
 * Copyright 2011 Frank Terbeck <ft@bewatermyfriend.org>, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR OR CONTRIBUTORS OF THE PROJECT BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @file cdce-scm.c
 * @brief Scheme API for cdce-remote
 *
 * The basic procedures are `cdce/open', `cdce/close', which open/close the
 * serial device file, `cdce/hi' and `cdce/bye', which initiate and terminate a
 * conversation with the serial device.
 */

#include <stdio.h>
#include <libguile.h>

#include "cdce-scm.h"
#include "common.h"
#include "proto.h"
#include "scm-helpers.h"
#include "serial.h"

SCM
cdce_scm_close(UNUSED SCM x)
{
    if (!serial_close()) {
        return SCM_BOOL_F;
    }
    return SCM_BOOL_T;
}

SCM
cdce_scm_open(SCM device)
{
    char *buf;
    SCM rc = SCM_BOOL_F;

    if (scm_string_p(device) == SCM_BOOL_F) {
        (void)printf("cdce/open: `device' must be a string.\n");
        return SCM_BOOL_F;
    } else if (scm_string_null_p(device) == SCM_BOOL_T) {
        (void)printf("cdce/open: `device' must be non-empty.\n");
        return SCM_BOOL_F;
    }

    buf = cdce_scm2string(device);
    if (buf == NULL)
        goto done;
    if (!serial_open(buf))
        goto done;

    rc = SCM_BOOL_T;

done:
    free(buf);
    return rc;
}

SCM
cdce_scm_hi(UNUSED SCM x)
{
    if (!proto_hi())
        return SCM_BOOL_F;
    if (!proto_expect_reply("Hi there, stranger."))
        return SCM_BOOL_F;

    return SCM_BOOL_T;
}

SCM
cdce_scm_bye(UNUSED SCM x)
{
    if (!proto_bye())
        return SCM_BOOL_F;
    if (!proto_expect_reply("Have a nice day."))
        return SCM_BOOL_F;

    return SCM_BOOL_T;
}

static struct cdce_scm_proctab {
    const char *name;
    SCM (*cb)(SCM);
    int req;
    int opt;
    int rest;
} pt[] = {
    { "cdce/bye", cdce_scm_bye, 0, 0, 0 },
    { "cdce/close", cdce_scm_close, 0, 0, 0 },
    { "cdce/hi", cdce_scm_hi, 0, 0, 0 },
    { "cdce/open", cdce_scm_open, 1, 0, 0 },
    { (char *)NULL, NULL, 0, 0, 0 }
};

void
cdce_scm_init(void)
{
    int i;

    scm_c_define("cdce/options:trace", SCM_BOOL_F);
    for (i = 0; pt[i].name != NULL; ++i) {
        scm_c_define_gsubr(pt[i].name,
                           pt[i].req,
                           pt[i].opt,
                           pt[i].rest,
                           pt[i].cb);
    }
}
