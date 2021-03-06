/*
 * Copyright (c) 2013-2018 chip-remote workers, All rights reserved.
 *
 * Terms for redistribution and use can be found in LICENCE.
 */

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "chip-remote.h"
#include "protocol.h"
#include "proto-utils.h"
#include "roles.h"
#include "utils.h"

static void
cr_echo_int(char *prefix, uint32_t num)
{
    tx_init();
    tx_add(prefix);
    tx_add_space();
    tx_add_integer(num);
    tx_trigger();
}

void
cr_echo_parameter(struct cr_parameter *p)
{
    tx_init();
    tx_add(p->name);
    tx_add_space();;
    tx_add(p->value.value);
    if (!p->value.mutable_p)
        tx_add(" FIXED");
    tx_trigger();
}

static void
cr_echo_int_property(char *reply, struct cr_int_prop *p)
{
    tx_init();
    tx_add(reply);
    tx_add_space();;
    tx_add_integer((uint32_t)p->value);
    if (!p->mutable_p)
        tx_add(" FIXED");
    tx_trigger();
}

static void
cr_echo_string_property(char *reply, struct cr_string_prop *p)
{
    tx_init();
    tx_add(reply);
    tx_add_space();;
    tx_add(p->value);
    if (!p->mutable_p)
        tx_add(" FIXED");
    tx_trigger();
}

void
cr_fail(char *reason)
{
    tx_init();
    tx_add(WTF_REPLY);
    if (reason != (char*)NULL) {
        tx_add_space();;
        tx_add(reason);
    }
    tx_trigger();
}

void
cr_broken_value(struct cr_words *words, size_t idx)
{
    tx_init();
    tx_add(BROKEN_VALUE_REPLY);
    tx_add_space();;
    tx_add_n(words->word[idx].start, words->word[idx].length);
    tx_trigger();
}

void
cr_unknown_param(char *key)
{
    tx_init();
    tx_add(WTF_REPLY);
    tx_add(" Unknown parameter: ");
    tx_add(key);
    tx_trigger();
}

void
cr_broken_param(char *key, char *value)
{
    tx_init();
    tx_add(BROKEN_VALUE_REPLY);
    tx_add_space();
    tx_add(key);
    tx_add(": ");
    tx_add(value);
    tx_trigger();
}

void
cr_uint_oor(uint32_t value)
{
    tx_init();
    tx_add(VALUE_OUT_OF_RANGE_REPLY);
    tx_add_space();
    tx_add_integer(value);
    tx_trigger();
}

void
cr_echo_line(size_t port, size_t line, enum cr_pin_role role, int idx,
             int mutable)
{
    tx_init();
    tx_add(LINE_REPLY);
    tx_add_space();
    tx_add_integer((uint32_t)port);
    tx_add_space();;
    tx_add_integer((uint32_t)line);
    tx_add_space();;
    tx_add(cr_id2role(role));
    if (idx >= 0) {
        tx_add(":");
        tx_add_integer((uint32_t)idx);
    }
    if (!mutable)
        tx_add(" FIXED");
    tx_trigger();
}

void
cr_echo_lines(struct cr_port *ports, size_t num)
{
    cr_echo_int(LINES_REPLY, (uint32_t)ports[num].lines);
}

void
cr_echo_rate(struct cr_port *ports, size_t num)
{
    if (ports[num].rate.value <= 0) {
        struct cr_string_prop sp;
        strncpy(sp.value, "0", CR_STRING_PROP_MAX);
        sp.mutable_p = ports[num].rate.mutable_p;
        cr_echo_string_property(RATE_REPLY, &sp);
    } else
        cr_echo_int_property(RATE_REPLY, &(ports[num].rate));
}

void
cr_echo_mode(struct cr_port *ports, size_t num)
{
    tx_init();
    tx_add("MODE ");
    switch (ports[num].mode.mode) {
    case CR_MODE_SPI:
        tx_add("SPI");
        break;
    case CR_MODE_PAREX:
        tx_add("PAREX");
        break;
    case CR_MODE_NONE:
    case CR_MODE_INVALID:
        tx_add("NONE");
    }
    if (!ports[num].mode.mutable_p)
        tx_add(" FIXED");
    tx_trigger();
}

void
cr_echo_ports(size_t num)
{
    cr_echo_int(PORTS_REPLY, (uint32_t)num);
}

void
cr_echo_focus(int num)
{
    if (num < 0)  {
        tx_init();
        tx_add(FOCUS_REPLY);
        tx_add(" NONE");
        tx_trigger();
        return;
    }
    cr_echo_int(FOCUS_REPLY, (uint32_t)num);
}
