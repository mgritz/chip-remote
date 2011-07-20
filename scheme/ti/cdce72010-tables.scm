;;;;
;; Copyright 2011 Frank Terbeck <ft@bewatermyfriend.org>, All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:
;;
;; 1. Redistributions of source code must retain the above copyright notice,
;;    this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation and/or other materials provided with the distribution.
;;
;; THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
;; INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
;; AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;; AUTHOR OR CONTRIBUTORS OF THE PROJECT BE LIABLE FOR ANY DIRECT, INDIRECT,
;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
;; NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
;; THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(define-module (ti cdce72010-tables)
  :export (divider-table
           factory-defaults
           get-bits-for-divider
           get-bits-for-output-mode
           output-modes
           register-content-table))

(define factory-defaults
  '(#x002c0040
    #x83840051
    #x83400002
    #x83400003
    #x81800004
    #x81800005
    #xeb040006
    #xeb040717
    #x010c0158
    #x01000049
    #x0bfc07ca
    #x0000058b
    #x61e09c0c))

(define divider-table
  ;; We need these to configure each output divider and the feedback divider.
  ;;
  ;; d   : divider setting
  ;; bits: register bits
  ;; cyc : phase-lag (cycles)
  ;; deg : phase-lag (degrees) [cyc * 360]
  ;;
  ;; d     bits       cyc    deg
  '(( 1  #b0100000    0.0      0)
    ( 2  #b1000000    0.5    180)
    ( 3  #b1000001    0.0      0)
    ( 4  #b1000010    0.5    180)
    ( 4  #b0000000   14.5   5220)
    ( 5  #b1000011    0.0      0)
    ( 6  #b0000001   21.0   7560)
    ( 8  #b0000010   28.5  10260)
    ( 8  #b0000100   16.5   5940)
    (10  #b0000011   35.0  12600)
    (12  #b0000101   24.0   8640)
    (12  #b0001000   18.5   6660)
    (16  #b0000110   32.5  11700)
    (16  #b0001100   20.5   7380)
    (18  #b0001001   27.0   9720)
    (20  #b0000111   40.0  14400)
    (20  #b0010000   22.5   8100)
    (24  #b0001010   36.5  13140)
    (24  #b0001101   30.0  10800)
    (24  #b0010100   24.5   8820)
    (28  #b0011000   26.5   9540)
    (30  #b0001011   45.0  16200)
    (30  #b0010001   33.0  11880)
    (32  #b0001110   40.5  14580)
    (32  #b0011100   28.5  10260)
    (36  #b0010101   36.0  12960)
    (40  #b0001111   50.0  18000)
    (40  #b0010010   40.0  16020)
    (42  #b0011001   39.0  14040)
    (48  #b0010110   48.5  17460)
    (48  #b0011101   42.0  15120)
    (50  #b0010011   50.0  19800)
    (56  #b0011010   52.5  18900)
    (60  #b0010111   60.0  21600)
    (64  #b0011110   56.5  20340)
    (70  #b0011011   65.0  23400)
    (80  #b0011111   70.0  25200)))

(define (get-bits-for-divider value)
  (let next((v divider-table))
    (cond
     ((null? v)
      (display (format #f "Invalid divider `~d'. Falling back to 80.\n" value))
      #b0011111)
     (else
      (if (= value (caar v))
          (cadar v)
          (next (cdr v)))))))

(define output-modes
  '((off           #b0110100)
    ;; for completeness, both pins can be low or 3-stated
    (both-3-state  #b0010100)
    (both-low      #b0001010)

    ;; the -high versions are the same mode, just with increased output swing
    (lvpecl        #b1000000)
    (lvpecl-high   #b1000001)

    (lvds          #b1110100)
    (lvds-high     #b1110101)

    ;; with -p/-n the opposing pin is 3-stated
    (lvcmos-p      #b0010010)
    (lvcmos-n      #b0001100)
    ;; p active (n driven low)
    (lvcmos-p-n0   #b0000010)
    ;; n active (p driven low)
    (lvcmos-n-p0   #b0001000)
    ;; both pins active, (synchronously)
    (lvcmos-p+n    #b0001010)
    ;; both pins active (180 degrees phase difference)
    (lvcmos-diff   #b0011010)))

(define (get-bits-for-output-mode mode)
  (let next ((m output-modes))
    (cond
     ((null? m)
      (display (format #f "Invalid mode specifier ~s.\n"
                       (symbol->string mode)))
      (display "Falling back to 'off.\n")
      #b0110100)
     (else
      (if (equal? mode (caar m))
          (cadar m)
          (next (cdr m)))))))

;; The following describes all register contents of the CDCE72010 device. The
;; first integer is the width of a bit-set. So all bit-set-widths of a register
;; should sum up to 32 bits.
(define register-content-table
  ;; #0
  '(((4 . address)
     (2 . in-buf-sel)
     (2 . pri-sec-sel)
     (1 . vcxo-sel)
     (1 . ref-sel-ctrl)
     (2 . delay-pfd)
     (1 . cp-mode)
     (1 . cp-direction)
     (1 . cp-src)
     (1 . cp-sink)
     (1 . cp-op-amp)
     (1 . cp-preset-output-voltage)
     (4 . cp-current)
     (2 . reserved)
     (1 . i-ref-pull-down)
     (7 . output-mode))
    ;; #1
    ((4 . address)
     (1 . ac-dc-sel)
     (1 . hyst-enable)
     (1 . input-termination)
     (1 . primary-input-bias)
     (1 . secondary-input-bias)
     (1 . fail-safe)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #2
    ((4 . address)
     (3 . delay-m)
     (3 . delay-n)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #3
    ((4 . address)
     (1 . disable-ref-freq-detect)
     (1 . disable-fb-freq-detect)
     (2 . bias-div01)
     (2 . bias-div23)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #4
    ((4 . address)
     (4 . reserved)
     (1 . hold-cp-on-loss-of-refclk)
     (1 . reserved)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #5
    ((4 . address)
     (2 . bias-div45)
     (2 . bias-div67)
     (2 . reserved)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #6
    ((4 . address)
     (1 . fb-freqdetect-connected-to-lockdetect)
     (1 . fb-determ-div-sel)
     (1 . fb-determ-div2-disable)
     (1 . fb-start-bypass)
     (1 . det-start-bypass)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #7
    ((4 . address)
     (2 . lock-detect-window-a)
     (1 . reserved)
     (2 . coherent-lock)
     (1 . analog-digital-lock-detect)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #8
    ((4 . address)
     (2 . vcxo-buf-sel)
     (1 . vcxo-ac-dc-sel)
     (1 . vcxo-hyst-enable)
     (1 . vcxo-input-termination)
     (1 . vcxo-input-bias)
     (7 . coarse-phase-adjust)
     (7 . output-divider)
     (1 . divider-enable)
     (7 . output-mode))
    ;; #9
    ((4 . address)
     (1 . external-hold-over-function)
     (1 . reserved)
     (1 . hold)
     (1 . lock-triggers-hold)
     (2 . hold-count)
     (2 . lock-detect-window-b)
     (1 . no-invert-reset-hold)
     (1 . divsync-dis)
     (1 . start-bypass)
     (1 . indet-bp)
     (1 . pll-lock-bypass)
     (1 . low-fd-fb-en)
     (1 . npreset-mdiv)
     (2 . bias-fb-div)
     (2 . bias-div89)
     (1 . aux-input-bias)
     (1 . disable-aux-input)
     (7 . output-mode))
    ;; #10
    ((4 . address)
     (14 . m-divider)
     (14 . n-divider))
    ;; #11
    ((4 . address)
     (1 . primary-reference-divider)
     (1 . secondary-reference-divider)
     (1 . fb-div-disable)
     (1 . fb-logic-mode-sel)
     (1 . fb-input-clk-invert)
     (7 . fb-divider)
     (7 . fb-coarse-phase-adjust)
     (1 . pll-power-down)
     (1 . fb-mux-sel)
     (1 . out-mux-sel)
     (1 . fb-sel)
     (1 . ref-clk-reshape)
     (1 . ref-clk-delay-sel)
     (1 . reset-hold-sel)
     (1 . eeprom-lock-status)
     (1 . eeprom-status))
    ;; #12
    ((4 . address)
     (4 . reserved)
     (1 . aux-in-present)
     (1 . vcxo-in-present)
     (1 . pll-lock-status)
     (1 . software-hold-reset)
     (1 . general-test-mode-enable)
     (3 . revision-control)
     (1 . power-down-io)
     (1 . sxoiref)
     (1 . route-hold-to-pll-lock)
     (1 . reserved)
     (4 . ti-test-status)
     (4 . ti-test-config)
     (1 . primary-ref-clk-present)
     (1 . secondary-ref-clk-present)
     (1 . reserved))))
