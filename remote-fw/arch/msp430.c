/*
 * Copyright (c) 2013-2014 chip-remote workers, All rights reserved.
 *
 * Terms for redistribution and use can be found in LICENCE.
 */

#include <stdint.h>

#include "../chip-remote.h"
#include "../platform.h"
#include "../protocol.h"
#include "../utils.h"
#include "../config.msp430.h"

#include "cr-msp430.h"

#define SETUP_PIN_READ(mask) (BITMASK_CLEAR(P5DIR, mask))
#define SETUP_PIN_WRITE(mask) (BITMASK_SET(P5DIR, mask))
#define PIN_WRITE(mask, value) (value ? BITMASK_SET(P5OUT, mask) \
                                      : BITMASK_CLEAR(P5OUT, mask))
#define PIN_READ(mask) ((P5IN | mask) ? 1 : 0)

int
access_port5(struct cr_line *line, enum cr_access_mode mode, int value)
{
    if (mode == CR_ACCESS_READ) {
        SETUP_PIN_READ(line->bitmask);
        return PIN_READ(line->bitmask);
    } else {
        SETUP_PIN_WRITE(line->bitmask);
        PIN_WRITE(line->bitmask, value);
        return 0;
    }
}

void
xcr_pre_top_level(void)
{
    /*
     * This function could be used to poll data from the UART port until a line
     * is complete and then work on that. The simulator version of the firmware
     * does exactly that. But on this microcontroller, we do have interupts and
     * we will use that to handle incoming data instead.  This doesn't have any
     * work to do, therefore.
     */
}

void
xcr_post_bye(void)
{
    /*
     * The xcr_post_bye function is mostly in place for the simulator version
     * of the firmware to be able to exit after the conversation is done. The
     * actual firmware should just wait for the next conversion. So this is a
     * no-op here.
     */
}

#define SEND_BYTE(byte)                         \
    do {                                        \
        while (!(IFG1 & UTXIFG0))               \
            /* NOP */;                          \
        U0TXBUF = byte;                         \
    } while (0)

void
xcr_send_host(char *buf)
{
    char *ptr;

    ptr = buf;
    while (*ptr != '\0') {
        SEND_BYTE(*ptr);
        ptr++;
    }
    SEND_BYTE('\n');
}

void
xcr_wait(uint32_t n)
{
    uint32_t i;

    for (i = 0; i < n; ++i)
        asm(" nop");
}

#define CR_RX_STATE_COPY 0
#define CR_RX_STATE_IGNORE 1

#ifndef MSPGCC_BUILD
/* Pragma for supporting TI's CodeComposerStudio */
#pragma vector=USART0RX_VECTOR
#endif /* NOT MSPGCC_BUILD */

XINTERRUPT(USART0RX_VECTOR, uart_rx_interrupt)
{
    static int inputlen = 0;
    static int state = CR_RX_STATE_COPY;
    uint8_t devnull;

    switch (state) {
    case CR_RX_STATE_COPY:
        if (inputlen >= CR_MAX_LINE) {
            /* Input too long! Ignoring everything until next newline! */
            inputlen = 0;
            state = CR_RX_STATE_IGNORE;
        } else if (U0RXBUF == '\n') {
            rxbuf[inputlen] = '\0';
            inputlen = 0;
            cr_set_line_pending(1);
        } else {
            rxbuf[inputlen] = U0RXBUF;
            inputlen++;
        }
        break;
    default:
        devnull = U0RXBUF;
        if (devnull == '\n') {
            xcr_send_host("WTF Input too long and therefore ignored.");
            state = CR_RX_STATE_COPY;
        }
    }
    return;
}
