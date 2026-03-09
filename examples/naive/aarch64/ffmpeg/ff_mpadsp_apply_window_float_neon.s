.global ff_mpadsp_apply_window_float_neon
ff_mpadsp_apply_window_float_neon:
        // MP3 synthesis polyphase filterbank, float variant.
        // Inner accumulation loop (label 2): 8 iterations, 14 instructions each.
        // Registers entering the loop:
        //   x8, x10 = synth_buf pointers (strided by x9)
        //   x6, x7, x11, x12 = window pointers (strided by x9)
        //   x9 = stride = 64*4
        //   v27 = byte-reversal tbl pattern
        //   v16, v18 = accumulators (initialised before loop)
        //   x15 = loop counter (8)
        mov             x15, #8
        movi            v16.4s, #0
        movi            v18.4s, #0
2:
        subs            x15, x15, #1
        ld1             {v0.4s},  [x8],  x9
        ld1             {v1.4s},  [x10], x9
        ld1             {v2.4s},  [x6],  x9
        ld1             {v3.4s},  [x7],  x9
        tbl             v6.16b, {v0.16b}, v27.16b
        tbl             v7.16b, {v1.16b}, v27.16b
        ld1             {v4.4s},  [x11], x9
        ld1             {v5.4s},  [x12], x9
        fmla            v16.4s, v2.4s, v0.4s
        fmls            v18.4s, v3.4s, v6.4s
        fmls            v16.4s, v4.4s, v7.4s
        fmls            v18.4s, v5.4s, v1.4s
        b.gt            2b
        ret
