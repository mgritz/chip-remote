;; Copyright (c) 2014 chip-remote workers, All rights reserved.
;;
;; Terms for redistribution and use can be found in LICENCE.

(define-module (chip-remote devices ti lmk04828 registers)
  #:use-module (bitops)
  #:use-module (chip-remote register-map))

(define-register-map lmk04828
  (#x0 (contents (reset 7 1)
                 (spi-3wire-dis 4 1)))
  (#x2 (contents (powerdown 0 1)))
  (#x3 (contents (id-device-type 0 8)))
  (#x4 (contents (id-prod-high 0 8)))
  (#x5 (contents (id-prod-low 0 8)))
  (#x6 (contents (id-maskrev 0 8)))
  (#xC (contents (id-vndr-high 0 8)))
  (#xD (contents (id-vndr-low 0 8)))
  (#x100 (contents (clkout0-1-odl 6 1)
                   (clkout0-1-idl 5 1)
                   (dclkout0-div 0 5)))
  (#x101 (contents (dclkout0-ddly-cnth 4 4)
                   (dclkout0-ddly-cntl 0 4)))
  (#x103 (contents (dclkout0-adly 3 5)
                   (dclkout0-adly-mux 2 1)
                   (dclkout0-mux 0 2)))
  (#x104 (contents (dclkout0-hs 6 1)
                   (sdclkout1-mux 5 1)
                   (sdclkout1-ddly 1 4)
                   (sdclkout1-hs 0 1)))
  (#x105 (contents (sdclkout1-adly-en 4 1)
                   (sdclkout1-adly 0 4)))
  (#x106 (contents (dclkout0-ddly-pd 7 1)
                   (dclkout0-hsg-pd 6 1)
                   (dclkout0-adlyg-pd 5 1)
                   (dclkout0-adly-pd 4 1)
                   (clkout0-1-pd 3 1)
                   (sdclkout1-dis-mode 1 2)
                   (sdclkout1-pd 0 1)))
  (#x107 (contents (sdclkout1-pol 7 1)
                   (clkout1-fmt 4 3)
                   (dclkout0-pol 3 1)
                   (clkout0-fmt 0 3)))
  (#x108 (contents (clkout2-3-odl 6 1)
                   (clkout2-3-idl 5 1)
                   (dclkout2-div 0 5)))
  (#x109 (contents (dclkout2-ddly-cnth 4 4)
                   (dclkout2-ddly-cntl 0 4)))
  (#x10B (contents (dclkout2-adly 3 5)
                   (dclkout2-adly-mux 2 1)
                   (dclkout2-mux 0 2)))
  (#x10C (contents (dclkout2-hs 6 1)
                   (sdclkout3-mux 5 1)
                   (sdclkout3-ddly 1 4)
                   (sdclkout3-hs 0 1)))
  (#x10D (contents (sdclkout3-adly-en 4 1)
                   (sdclkout3-adly 0 4)))
  (#x10E (contents (dclkout2-ddly-pd 7 1)
                   (dclkout2-hsg-pd 6 1)
                   (dclkout2-adlyg-pd 5 1)
                   (dclkout2-adly-pd 4 1)
                   (clkout2-3-pd 3 1)
                   (sdclkout3-dis-mode 1 2)
                   (sdclkout3-pd 0 1)))
  (#x10F (contents (sdclkout3-pol 7 1)
                   (clkout3-fmt 4 3)
                   (dclkout2-pol 3 1)
                   (clkout2-fmt 0 3)))
  (#x110 (contents (clkout4-5-odl 6 1)
                   (clkout4-5-idl 5 1)
                   (dclkout4-div 0 5)))
  (#x111 (contents (dclkout4-ddly-cnth 4 4)
                   (dclkout4-ddly-cntl 0 4)))
  (#x113 (contents (dclkout4-adly 3 5)
                   (dclkout4-adly-mux 2 1)
                   (dclkout4-mux 0 2)))
  (#x114 (contents (dclkout4-hs 6 1)
                   (sdclkout5-mux 5 1)
                   (sdclkout5-ddly 1 4)
                   (sdclkout5-hs 0 1)))
  (#x115 (contents (sdclkout5-adly-en 4 1)
                   (sdclkout5-adly 0 4)))
  (#x116 (contents (dclkout4-ddly-pd 7 1)
                   (dclkout4-hsg-pd 6 1)
                   (dclkout4-adlyg-pd 5 1)
                   (dclkout4-adly-pd 4 1)
                   (clkout4-5-pd 3 1)
                   (sdclkout5-dis-mode 1 2)
                   (sdclkout5-pd 0 1)))
  (#x117 (contents (sdclkout5-pol 7 1)
                   (clkout5-fmt 4 3)
                   (dclkout4-pol 3 1)
                   (clkout4-fmt 0 3)))
  (#x118 (contents (clkout6-7-odl 6 1)
                   (clkout6-8-idl 5 1)
                   (dclkout6-div 0 5)))
  (#x119 (contents (dclkout6-ddly-cnth 4 4)
                   (dclkout6-ddly-cntl 0 4)))
  (#x11B (contents (dclkout6-adly 3 5)
                   (dclkout6-adly-mux 2 1)
                   (dclkout6-mux 0 2)))
  (#x11C (contents (dclkout6-hs 6 1)
                   (sdclkout7-mux 5 1)
                   (sdclkout7-ddly 1 4)
                   (sdclkout7-hs 0 1)))
  (#x11D (contents (sdclkout7-adly-en 4 1)
                   (sdclkout7-adly 0 4)))
  (#x11E (contents (dclkout6-ddly-pd 7 1)
                   (dclkout6-hsg-pd 6 1)
                   (dclkout6-adlyg-pd 5 1)
                   (dclkout6-adly-pd 4 1)
                   (clkout6-7-pd 3 1)
                   (sdclkout7-dis-mode 1 2)
                   (sdclkout7-pd 0 1)))
  (#x11F (contents (sdclkout7-pol 7 1)
                   (clkout7-fmt 4 3)
                   (dclkout6-pol 3 1)
                   (clkout6-fmt 0 3)))
  (#x120 (contents (clkout8-9-odl 6 1)
                   (clkout8-9-idl 5 1)
                   (dclkout8-div 0 5)))
  (#x121 (contents (dclkout8-ddly-cnth 4 4)
                   (dclkout8-ddly-cntl 0 4)))
  (#x123 (contents (dclkout8-adly 3 5)
                   (dclkout8-adly-mux 2 1)
                   (dclkout8-mux 0 2)))
  (#x124 (contents (dclkout8-hs 6 1)
                   (sdclkout9-mux 5 1)
                   (sdclkout9-ddly 1 4)
                   (sdclkout9-hs 0 1)))
  (#x125 (contents (sdclkout9-adly-en 4 1)
                   (sdclkout9-adly 0 4)))
  (#x126 (contents (dclkout8-ddly-pd 7 1)
                   (dclkout8-hsg-pd 6 1)
                   (dclkout8-adlyg-pd 5 1)
                   (dclkout8-adly-pd 4 1)
                   (clkout8-9-pd 3 1)
                   (sdclkout9-dis-mode 1 2)
                   (sdclkout9-pd 0 1)))
  (#x127 (contents (sdclkout9-pol 7 1)
                   (clkout9-fmt 4 3)
                   (dclkout8-pol 3 1)
                   (clkout8-fmt 0 3)))
  (#x128 (contents (clkout10-11-odl 6 1)
                   (clkout10-11-idl 5 1)
                   (dclkout10-div 0 5)))
  (#x129 (contents (dclkout10-ddly-cnth 4 4)
                   (dclkout10-ddly-cntl 0 4)))
  (#x12B (contents (dclkout10-adly 3 5)
                   (dclkout10-adly-mux 2 1)
                   (dclkout10-mux 0 2)))
  (#x12C (contents (dclkout10-hs 6 1)
                   (sdclkout11-mux 5 1)
                   (sdclkout11-ddly 1 4)
                   (sdclkout11-hs 0 1)))
  (#x12D (contents (sdcklout11-adly-en 4 1)
                   (sdclkout11-adly 0 4)))
  (#x12E (contents (dclkout10-ddly-pd 7 1)
                   (dclkout10-hsg-pd 6 1)
                   (dlclkout10-adlyg-pd 5 1)
                   (dclkout10-adly-pd 4 1)
                   (clkout10-11-pd 3 1)
                   (sdclkout11-dis-mode 1 2)
                   (sdclkout11-pd 0 1)))
  (#x12F (contents (sdclkout11-pol 7 1)
                   (clkout11-fmt 4 3)
                   (dclkout10-pol 3 1)
                   (clkout10-fmt 0 3)))
  (#x130 (contents (clkout12-13-odl 6 1)
                   (clkout12-13-idl 5 1)
                   (dclkout12-div 0 5)))
  (#x131 (contents (dclkout12-ddly-cnth 4 4)
                   (dclkout12-ddly-cntl 0 4)))
  (#x133 (contents (dclkout12-adly 3 5)
                   (dclkout12-adly-mux 2 1)
                   (dclkout12-mux 0 2)))
  (#x134 (contents (dclkout12-hs 6 1)
                   (sdclkout13-mux 5 1)
                   (sdclkout13-ddly 1 4)
                   (sdclkout13-hs 0 1)))
  (#x135 (contents (sdclkout13-adly-en 4 1)
                   (sdclkout13-adly 0 4)))
  (#x136 (contents (dclkout12-ddly-pd 7 1)
                   (dclkout12-hsg-pd 6 1)
                   (dclkout12-adlyg-pd 5 1)
                   (dclkout12-adly-pd 4 1)
                   (clkout12-13-pd 3 1)
                   (sdclkout13-dis-mode 1 2)
                   (sdclkout13-pd 0 1)))
  (#x137 (contents (sdclkout13-pol 7 1)
                   (clkout13-fmt 4 3)
                   (dclkout12-pol 3 1)
                   (clkout12-fmt 0 3)))
  (#x138 (contents (vco-mux 5 2)
                   (oscout-mux 4 1)
                   (oscout-fmt 0 4)))
  (#x139 (contents (sysref-mux 0 2)))
  (#x13A (contents (sysref-div-high 0 5)))
  (#x13B (contents (sysref-div-low 0 8)))
  (#x13C (contents (sysref-ddly-low 0 5)))
  (#x13D (contents (sysref-ddly-high 0 8)))
  (#x13E (contents (sysref-pulse-cnt 0 2)))
  (#x13F (contents (pll2-nclk-mux 4 1)
                   (pll1-nclk-mux 3 1)
                   (fb-mux 1 2)
                   (fb-mux-en 0 1)))
  (#x140 (contents (pll1-pd 7 1)
                   (vco-ldo-pd 6 1)
                   (vco-pd 5 1)
                   (oscin-pd 4 1)
                   (sysref-gbl-pd 3 1)
                   (sysref-pd 2 1)
                   (sysref-ddly-pd 1 1)
                   (sysref-plsr-pd 0 1)))
  (#x141 (contents (ddlyd-sysref-en 7 1)
                   (ddlyd12-en 6 1)
                   (ddlyd10-en 5 1)
                   (ddlyd7-en 4 1)
                   (ddlyd6-en 3 1)
                   (ddlyd4-en 2 1)
                   (ddlyd2-en 1 1)
                   (ddlyd0-en 0 1)))
  (#x142 (contents (ddlyd-step-cnt 0 5)))
  (#x143 (contents (sysref-ddly-clr 7 1)
                   (sync-1shot-en 6 1)
                   (sync-pol 5 1)
                   (sync-en 4 1)
                   (sync-pll2-dld 3 1)
                   (sync-pll1-dld 2 1)
                   (sync-mode 0 2)))
  (#x144 (contents (sync-dissysref 7 1)
                   (sync-dis12 6 1)
                   (sync-dis10 5 1)
                   (sync-dis8 4 1)
                   (sync-dis6 3 1)
                   (sync-dis4 2 1)
                   (sync-dis2 1 1)
                   (sync-dis0 0 1)))
  (#x145 (contents ))
  (#x146 (contents (clkin2-en 5 1)
                   (clkin1-en 4 1)
                   (clkin0-en 3 1)
                   (clkin2-type 2 1)
                   (clkin1-type 1 1)
                   (clkin0-type 0 1)))
  (#x147 (contents (clkin-sel-pol 7 1)
                   (clkin-sel-mode 4 3)
                   (clkin1-out-mux 2 2)
                   (clkin0-out-mux 0 2)))
  (#x148 (contents (clkin-sel0-mux 3 3)
                   (clkin-sel0-type 0 3)))
  (#x149 (contents (sdio-rdbk-type 6 1)
                   (clkin-sel1-mux 3 3)
                   (clkin-sel1-type 0 3)))
  (#x14A (contents (reset-mux 3 3)
                   (reset-type 0 3)))
  (#x14B (contents (los-timeout 6 2)
                   (los-en 5 1)
                   (track-en 4 1)
                   (holdover-force 3 1)
                   (man-dac-en 2 1)
                   (man-dac-high 0 2)))
  (#x14C (contents (man-dac-low 0 8)))
  (#x14D (contents (dac-trip-low 0 6)))
  (#x14E (contents (dac-clk-mult 6 2)
                   (dac-trip-high 0 6)))
  (#x14F (contents (dac-clk-cntr 0 8)))
  (#x150 (contents (holdover-pll1-det 4 1)
                   (holdover-los-det 3 1)
                   (holdover-vtune-det 2 1)
                   (holdover-hitless-switch 1 1)
                   (holdover-en 0 1)))
  (#x151 (contents (holdover-dld-cnt-high 0 6)))
  (#x152 (contents (holdover-dld-cnt-low 0 8)))
  (#x153 (contents (clkin0-r-high 0 6)))
  (#x154 (contents (clkin0-r-low 0 8)))
  (#x155 (contents (clkin1-r-high 0 6)))
  (#x156 (contents (clkin1-r-low 0 8)))
  (#x157 (contents (clkin2-r-high 0 6)))
  (#x158 (contents (clkin2-r-low 0 8)))
  (#x159 (contents (pll1-n-high 0 6)))
  (#x15A (contents (pll1-n-low 0 8)))
  (#x15B (contents (pll1-wnd-size 6 2)
                   (pll1-cp-tri 5 1)
                   (pll1-cp-pol 4 1)
                   (pll1-cp-gain 0 4)))
  (#x15C (contents (pll1-dld-cnt-high 0 6)))
  (#x15D (contents (pll1-dld-cnt-low 0 8)))
  (#x15E (contents (pll1-r-dly 3 3)
                   (pll1-n-dly 0 3)))
  (#x15F (contents (pll1-ld-mux 3 5)
                   (pll1-ld-type 0 3)))
  (#x160 (contents (pll2-r-high 0 4)))
  (#x161 (contents (pll2-r-low 0 8)))
  (#x162 (contents (pll2-p 5 3)
                   (oscin-freq 2 3)
                   (pll2-xtal-en 1 1)
                   (pll2-ref-2x-en 0 1)))
  (#x163 (contents (pll2-n-cal-high 0 2)))
  (#x164 (contents (pll2-n-cal-mid 0 8)))
  (#x165 (contents (pll2-n-cal-low 0 8)))
  (#x166 (contents (pll2-fcal-dis 2 1)
                   (pll2-n-high 0 2)))
  (#x167 (contents (pll2-n-mid 0 8)))
  (#x168 (contents (pll2-n-low 0 8)))
  (#x169 (contents (pll2-wnd-size 5 2)
                   (pll2-cp-gain 3 2)
                   (pll2-cp-pol 2 1)
                   (pll2-cp-tri 1 1)))
  (#x16A (contents (sysref-req-en 6 1)
                   (pll2-dld-cnt-high 0 6)))
  (#x16B (contents (pll2-dld-cnt-low 0 8)))
  (#x16C (contents (pll2-lf-r4 3 3)
                   (pll2-lf-r3 0 3)))
  (#x16D (contents (pll2-lf-c4 4 4)
                   (pll2-lf-c3 0 4)))
  (#x16E (contents (pll2-ld-mux 3 5)
                   (pll2-ld-type 0 3)))
  (#x173 (contents (pll2-pre-pd 6 1)
                   (pll2-pd 5 1)))
  (#x17C (contents (opt-reg-1 0 8)))
  (#x17D (contents (opt-reg-2 0 8)))
  (#x182 (contents (rb-pll1-ld-lost 2 1)
                   (rb-pll1-ld 1 1)
                   (clr-pll1-ld-lost 0 1)))
  (#x183 (contents (rb-pll2-ld-lost 2 1)
                   (rb-pll2-ld 1 1)
                   (clr-pll2-ld-lost 0 1)))
  (#x184 (contents (rb-dac-value-high 6 2)
                   (rb-clkin2-sel 5 1)
                   (rb-clkin1-sel 4 1)
                   (rb-clkin0-sel 3 1)
                   (rb-clkin1-los 1 1)
                   (rb-clkin0-los 0 1)))
  (#x185 (contents (rb-dac-value-low 0 8)))
  (#x188 (contents (rb-holdover 4 1)))
  (#x1FFD (contents (spi-lock-high 0 8)))
  (#x1FFE (contents (spi-lock-mid 0 8)))
  (#x1FFF (contents (spi-lock-low 0 8))))
