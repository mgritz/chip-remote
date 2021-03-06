/*
 * Copyright (c) 2013-2018 chip-remote workers, All rights reserved.
 *
 * Terms for redistribution and use can be found in LICENCE.
 */

#ifndef INC_LINE_MAPS_H
#define INC_LINE_MAPS_H

struct cr_spi_map {
    struct cr_line *clk;
    struct cr_line *mosi;
    struct cr_line *miso;
    struct cr_line **cs;
    /** currently ignored */
    int clk_rate;
    /** integer: number of chip-select-lines */
    int cs_lines_num;
    /** [0|1] Chip Select Polarity */
    int cs_polarity;
    /** [0|1] Clock Polarity */
    int clk_polarity;
    /** [0|1] Clock Phase Delay */
    int clk_phase_delay;
    int frame_length;
    /** [SPI_MSB_FIRST|SPI_LSB_FIRST] */
    int bit_order;
    /** Chip-Select Addressing bitmask */
    uint32_t address;
};

struct cr_parex_map {
    struct cr_line *clk;
    struct cr_line **addr;
    struct cr_line **data;
};

#endif /* INC_LINE_MAPS_H */
