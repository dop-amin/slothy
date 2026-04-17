.global ff_h264_idct_add_neon
ff_h264_idct_add_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264idct_neon.S
// function ff_h264_idct_add_neon
//
// x0 = dst (uint8_t*, stride x2)
// x1 = block (int16_t[4][4], zeroed on exit)
// w2 = stride

body_start:
        ld1             {v0.4h, v1.4h, v2.4h, v3.4h}, [x1]
        sxtw            x2,  w2
        movi            v30.8h, #0

        add             v4.4h,  v0.4h,  v2.4h
        sshr            v16.4h, v1.4h,  #1
        st1             {v30.8h}, [x1], #16
        sshr            v17.4h, v3.4h,  #1
        st1             {v30.8h}, [x1], #16
        sub             v5.4h,  v0.4h,  v2.4h
        sub             v6.4h,  v16.4h, v3.4h
        add             v7.4h,  v1.4h,  v17.4h
        add             v0.4h,  v4.4h,  v7.4h
        add             v1.4h,  v5.4h,  v6.4h
        sub             v2.4h,  v5.4h,  v6.4h
        sub             v3.4h,  v4.4h,  v7.4h

        // transpose_4x4H v0, v1, v2, v3, v4, v5, v6, v7
        trn1            v4.4h,  v0.4h,  v1.4h
        trn2            v5.4h,  v0.4h,  v1.4h
        trn1            v6.4h,  v2.4h,  v3.4h
        trn2            v7.4h,  v2.4h,  v3.4h
        trn1            v0.2s,  v4.2s,  v6.2s
        trn2            v2.2s,  v4.2s,  v6.2s
        trn1            v1.2s,  v5.2s,  v7.2s
        trn2            v3.2s,  v5.2s,  v7.2s

        add             v4.4h,  v0.4h,  v2.4h
        ld1             {v18.s}[0], [x0], x2
        sshr            v16.4h, v3.4h,  #1
        sshr            v17.4h, v1.4h,  #1
        ld1             {v18.s}[1], [x0], x2
        sub             v5.4h,  v0.4h,  v2.4h
        ld1             {v19.s}[1], [x0], x2
        add             v6.4h,  v16.4h, v1.4h
        ins             v4.d[1],  v5.d[0]
        sub             v7.4h,  v17.4h, v3.4h
        ld1             {v19.s}[0], [x0], x2
        ins             v6.d[1],  v7.d[0]
        sub             x0,  x0,  x2,  lsl #2
        add             v0.8h,  v4.8h,  v6.8h
        sub             v1.8h,  v4.8h,  v6.8h

        srshr           v0.8h,  v0.8h,  #6
        srshr           v1.8h,  v1.8h,  #6

        uaddw           v0.8h,  v0.8h,  v18.8b
        uaddw           v1.8h,  v1.8h,  v19.8b

        sqxtun          v0.8b,  v0.8h
        sqxtun          v1.8b,  v1.8h

        st1             {v0.s}[0], [x0], x2
        st1             {v0.s}[1], [x0], x2
        st1             {v1.s}[1], [x0], x2
        st1             {v1.s}[0], [x0], x2
body_end:

        sub             x1,  x1,  #32
        ret
