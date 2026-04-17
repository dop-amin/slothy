.global ff_h264_idct8_add_neon
ff_h264_idct8_add_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264idct_neon.S
// function ff_h264_idct8_add_neon
//
// x0 = dst (uint8_t*, stride x2)
// x1 = block (int16_t[8][8], zeroed on exit)
// w2 = stride

        movi            v19.8h,   #0
        sxtw            x2,       w2
body_start:
        // --- load block + zero it ---
        ld1             {v24.8h, v25.8h}, [x1]
        st1             {v19.8h},  [x1],   #16
        st1             {v19.8h},  [x1],   #16
        ld1             {v26.8h, v27.8h}, [x1]
        st1             {v19.8h},  [x1],   #16
        st1             {v19.8h},  [x1],   #16
        ld1             {v28.8h, v29.8h}, [x1]
        st1             {v19.8h},  [x1],   #16
        st1             {v19.8h},  [x1],   #16

        // --- idct8x8_cols pass=0 ---
        // va .req v18, vb .req v30
        sshr            v18.8h, v26.8h, #1
        add             v16.8h, v24.8h, v28.8h
        ld1             {v30.8h, v31.8h}, [x1]
        st1             {v19.8h}, [x1],  #16
        st1             {v19.8h}, [x1],  #16
        sub             v17.8h,  v24.8h, v28.8h
        sshr            v19.8h,  v30.8h, #1
        sub             v18.8h,  v18.8h,  v30.8h
        add             v19.8h,  v19.8h,  v26.8h
        // common part
        add             v26.8h, v17.8h, v18.8h
        sub             v28.8h, v17.8h, v18.8h
        add             v24.8h, v16.8h, v19.8h
        sub             v30.8h,  v16.8h, v19.8h
        sub             v16.8h, v29.8h, v27.8h
        add             v17.8h, v31.8h, v25.8h
        sub             v18.8h,  v31.8h, v25.8h
        add             v19.8h, v29.8h, v27.8h
        sub             v16.8h, v16.8h, v31.8h
        sub             v17.8h, v17.8h, v27.8h
        add             v18.8h,  v18.8h,  v29.8h
        add             v19.8h, v19.8h, v25.8h
        sshr            v25.8h, v25.8h, #1
        sshr            v27.8h, v27.8h, #1
        sshr            v29.8h, v29.8h, #1
        sshr            v31.8h, v31.8h, #1
        sub             v16.8h, v16.8h, v31.8h
        sub             v17.8h, v17.8h, v27.8h
        add             v18.8h,  v18.8h,  v29.8h
        add             v19.8h, v19.8h, v25.8h
        sshr            v25.8h, v16.8h, #2
        sshr            v27.8h, v17.8h, #2
        sshr            v29.8h, v18.8h,  #2
        sshr            v31.8h, v19.8h, #2
        sub             v19.8h, v19.8h, v25.8h
        sub             v18.8h,  v27.8h, v18.8h
        add             v17.8h, v17.8h, v29.8h
        add             v16.8h, v16.8h, v31.8h
        // pass=0 final reorder
        sub             v31.8h, v24.8h, v19.8h
        add             v24.8h, v24.8h, v19.8h
        add             v25.8h, v26.8h, v18.8h
        sub             v18.8h, v26.8h, v18.8h
        add             v26.8h, v28.8h, v17.8h
        add             v27.8h, v30.8h, v16.8h
        sub             v29.8h, v28.8h, v17.8h
        sub             v28.8h, v30.8h, v16.8h

        // --- transpose_8x8H v24,v25,v26,v27,v28,v29,v18,v31,v6,v7 ---
        // r0=v24 r1=v25 r2=v26 r3=v27 r4=v28 r5=v29 r6=v18 r7=v31 r8=v6 r9=v7
        // Stage 1: 8h transposes
        trn1            v6.8h,  v24.8h, v25.8h
        trn2            v7.8h,  v24.8h, v25.8h
        trn1            v25.8h, v26.8h, v27.8h
        trn2            v27.8h, v26.8h, v27.8h
        trn1            v24.8h, v28.8h, v29.8h
        trn2            v29.8h, v28.8h, v29.8h
        trn1            v26.8h, v18.8h, v31.8h
        trn2            v31.8h, v18.8h, v31.8h
        // Stage 2: 4s transposes
        trn1            v28.4s, v24.4s, v26.4s
        trn2            v26.4s, v24.4s, v26.4s
        trn1            v18.4s, v29.4s, v31.4s
        trn2            v31.4s, v29.4s, v31.4s
        trn1            v29.4s, v7.4s,  v27.4s
        trn2            v7.4s,  v7.4s,  v27.4s
        trn1            v27.4s, v6.4s,  v25.4s
        trn2            v6.4s,  v6.4s,  v25.4s
        // Stage 3: 2d transposes
        trn1            v24.2d, v27.2d, v28.2d
        trn2            v28.2d, v27.2d, v28.2d
        trn1            v25.2d, v29.2d, v18.2d
        trn2            v29.2d, v29.2d, v18.2d
        trn2            v18.2d, v6.2d,  v26.2d
        trn1            v26.2d, v6.2d,  v26.2d
        trn1            v27.2d, v7.2d,  v31.2d
        trn2            v31.2d, v7.2d,  v31.2d

        // --- idct8x8_cols pass=1 ---
        // va .req v30, vb .req v18
        sshr            v30.8h, v26.8h, #1
        sshr            v19.8h, v18.8h, #1
        add             v16.8h, v24.8h, v28.8h
        sub             v17.8h, v24.8h, v28.8h
        sub             v30.8h, v30.8h, v18.8h
        add             v19.8h, v19.8h, v26.8h
        // common part
        add             v26.8h, v17.8h, v30.8h
        sub             v28.8h, v17.8h, v30.8h
        add             v24.8h, v16.8h, v19.8h
        sub             v18.8h,  v16.8h, v19.8h
        sub             v16.8h, v29.8h, v27.8h
        add             v17.8h, v31.8h, v25.8h
        sub             v30.8h,  v31.8h, v25.8h
        add             v19.8h, v29.8h, v27.8h
        sub             v16.8h, v16.8h, v31.8h
        sub             v17.8h, v17.8h, v27.8h
        add             v30.8h,  v30.8h,  v29.8h
        add             v19.8h, v19.8h, v25.8h
        sshr            v25.8h, v25.8h, #1
        sshr            v27.8h, v27.8h, #1
        sshr            v29.8h, v29.8h, #1
        sshr            v31.8h, v31.8h, #1
        sub             v16.8h, v16.8h, v31.8h
        sub             v17.8h, v17.8h, v27.8h
        add             v30.8h,  v30.8h,  v29.8h
        add             v19.8h, v19.8h, v25.8h
        sshr            v25.8h, v16.8h, #2
        sshr            v27.8h, v17.8h, #2
        sshr            v29.8h, v30.8h,  #2
        sshr            v31.8h, v19.8h, #2
        sub             v19.8h, v19.8h, v25.8h
        sub             v30.8h,  v27.8h, v30.8h
        add             v17.8h, v17.8h, v29.8h
        add             v16.8h, v16.8h, v31.8h
        // pass=1 final reorder
        sub             v31.8h, v24.8h, v19.8h
        add             v24.8h, v24.8h, v19.8h
        add             v25.8h, v26.8h, v30.8h
        sub             v30.8h, v26.8h, v30.8h
        add             v26.8h, v28.8h, v17.8h
        sub             v29.8h, v28.8h, v17.8h
        add             v27.8h, v18.8h, v16.8h
        sub             v28.8h, v18.8h, v16.8h

        // --- shift + load pixels + add + clip + store ---
        mov             x3,  x0
        srshr           v24.8h, v24.8h, #6
        ld1             {v0.8b},     [x0], x2
        srshr           v25.8h, v25.8h, #6
        ld1             {v1.8b},     [x0], x2
        srshr           v26.8h, v26.8h, #6
        ld1             {v2.8b},     [x0], x2
        srshr           v27.8h, v27.8h, #6
        ld1             {v3.8b},     [x0], x2
        srshr           v28.8h, v28.8h, #6
        ld1             {v4.8b},     [x0], x2
        srshr           v29.8h, v29.8h, #6
        ld1             {v5.8b},     [x0], x2
        srshr           v30.8h, v30.8h, #6
        ld1             {v6.8b},     [x0], x2
        srshr           v31.8h, v31.8h, #6
        ld1             {v7.8b},     [x0], x2
        uaddw           v24.8h, v24.8h, v0.8b
        uaddw           v25.8h, v25.8h, v1.8b
        uaddw           v26.8h, v26.8h, v2.8b
        sqxtun          v0.8b,  v24.8h
        uaddw           v27.8h, v27.8h, v3.8b
        sqxtun          v1.8b,  v25.8h
        uaddw           v28.8h, v28.8h, v4.8b
        sqxtun          v2.8b,  v26.8h
        st1             {v0.8b},     [x3], x2
        uaddw           v29.8h, v29.8h, v5.8b
        sqxtun          v3.8b,  v27.8h
        st1             {v1.8b},     [x3], x2
        uaddw           v30.8h, v30.8h, v6.8b
        sqxtun          v4.8b,  v28.8h
        st1             {v2.8b},     [x3], x2
        uaddw           v31.8h, v31.8h, v7.8b
        sqxtun          v5.8b,  v29.8h
        st1             {v3.8b},     [x3], x2
        sqxtun          v6.8b,  v30.8h
        sqxtun          v7.8b,  v31.8h
        st1             {v4.8b},     [x3], x2
        st1             {v5.8b},     [x3], x2
        st1             {v6.8b},     [x3], x2
        st1             {v7.8b},     [x3], x2
body_end:

        sub             x1,  x1,  #128
        ret
