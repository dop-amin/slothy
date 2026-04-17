.global put_h264_qpel8_hv_lowpass_neon_top
put_h264_qpel8_hv_lowpass_neon_top:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264qpel_neon.S
// function put_h264_qpel8_hv_lowpass_neon_top
//
// x0 = dst (unused in this top half, but live for caller)
// x1 = src, x3 = src_stride
// v6.h[1]=20, v6.h[0]=5 are initialised here via lowpass_const
//
// lowpass_const w12 -- sets v6, not part of the optimized body
        movz            w12, #20, lsl #16
        movk            w12, #5
        mov             v6.s[0], w12

        // --- 13 row loads (.8h = 16-byte, post-inc by x3) ---
body_start:
        ld1             {v16.8h}, [x1], x3
        ld1             {v17.8h}, [x1], x3
        ld1             {v18.8h}, [x1], x3
        ld1             {v19.8h}, [x1], x3
        ld1             {v20.8h}, [x1], x3
        ld1             {v21.8h}, [x1], x3
        ld1             {v22.8h}, [x1], x3
        ld1             {v23.8h}, [x1], x3
        ld1             {v24.8h}, [x1], x3
        ld1             {v25.8h}, [x1], x3
        ld1             {v26.8h}, [x1], x3
        ld1             {v27.8h}, [x1], x3
        ld1             {v28.8h}, [x1]

        // --- lowpass_8H v16, v17 ---
        // trashes v0-v5, v7, v30-v31
        ext             v0.16b,     v16.16b, v16.16b, #2
        ext             v1.16b,     v16.16b, v16.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v16.16b, v16.16b, #1
        ext             v3.16b,     v16.16b, v16.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v16.16b, v16.16b, #5
        uaddl           v16.8h,     v16.8b,  v30.8b
        ext             v4.16b,     v17.16b, v17.16b, #2
        mla             v16.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v17.16b, v17.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v17.16b, v17.16b, #1
        mls             v16.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v17.16b, v17.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v17.16b, v17.16b, #5
        uaddl           v17.8h,     v17.8b,  v31.8b
        mla             v17.8h,     v4.8h,   v6.h[1]
        mls             v17.8h,     v7.8h,   v6.h[0]

        // --- lowpass_8H v18, v19 ---
        ext             v0.16b,     v18.16b, v18.16b, #2
        ext             v1.16b,     v18.16b, v18.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v18.16b, v18.16b, #1
        ext             v3.16b,     v18.16b, v18.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v18.16b, v18.16b, #5
        uaddl           v18.8h,     v18.8b,  v30.8b
        ext             v4.16b,     v19.16b, v19.16b, #2
        mla             v18.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v19.16b, v19.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v19.16b, v19.16b, #1
        mls             v18.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v19.16b, v19.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v19.16b, v19.16b, #5
        uaddl           v19.8h,     v19.8b,  v31.8b
        mla             v19.8h,     v4.8h,   v6.h[1]
        mls             v19.8h,     v7.8h,   v6.h[0]

        // --- lowpass_8H v20, v21 ---
        ext             v0.16b,     v20.16b, v20.16b, #2
        ext             v1.16b,     v20.16b, v20.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v20.16b, v20.16b, #1
        ext             v3.16b,     v20.16b, v20.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v20.16b, v20.16b, #5
        uaddl           v20.8h,     v20.8b,  v30.8b
        ext             v4.16b,     v21.16b, v21.16b, #2
        mla             v20.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v21.16b, v21.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v21.16b, v21.16b, #1
        mls             v20.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v21.16b, v21.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v21.16b, v21.16b, #5
        uaddl           v21.8h,     v21.8b,  v31.8b
        mla             v21.8h,     v4.8h,   v6.h[1]
        mls             v21.8h,     v7.8h,   v6.h[0]

        // --- lowpass_8H v22, v23 ---
        ext             v0.16b,     v22.16b, v22.16b, #2
        ext             v1.16b,     v22.16b, v22.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v22.16b, v22.16b, #1
        ext             v3.16b,     v22.16b, v22.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v22.16b, v22.16b, #5
        uaddl           v22.8h,     v22.8b,  v30.8b
        ext             v4.16b,     v23.16b, v23.16b, #2
        mla             v22.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v23.16b, v23.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v23.16b, v23.16b, #1
        mls             v22.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v23.16b, v23.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v23.16b, v23.16b, #5
        uaddl           v23.8h,     v23.8b,  v31.8b
        mla             v23.8h,     v4.8h,   v6.h[1]
        mls             v23.8h,     v7.8h,   v6.h[0]

        // --- lowpass_8H v24, v25 ---
        ext             v0.16b,     v24.16b, v24.16b, #2
        ext             v1.16b,     v24.16b, v24.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v24.16b, v24.16b, #1
        ext             v3.16b,     v24.16b, v24.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v24.16b, v24.16b, #5
        uaddl           v24.8h,     v24.8b,  v30.8b
        ext             v4.16b,     v25.16b, v25.16b, #2
        mla             v24.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v25.16b, v25.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v25.16b, v25.16b, #1
        mls             v24.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v25.16b, v25.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v25.16b, v25.16b, #5
        uaddl           v25.8h,     v25.8b,  v31.8b
        mla             v25.8h,     v4.8h,   v6.h[1]
        mls             v25.8h,     v7.8h,   v6.h[0]

        // --- lowpass_8H v26, v27 ---
        ext             v0.16b,     v26.16b, v26.16b, #2
        ext             v1.16b,     v26.16b, v26.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v26.16b, v26.16b, #1
        ext             v3.16b,     v26.16b, v26.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v26.16b, v26.16b, #5
        uaddl           v26.8h,     v26.8b,  v30.8b
        ext             v4.16b,     v27.16b, v27.16b, #2
        mla             v26.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v27.16b, v27.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v27.16b, v27.16b, #1
        mls             v26.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v27.16b, v27.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v27.16b, v27.16b, #5
        uaddl           v27.8h,     v27.8b,  v31.8b
        mla             v27.8h,     v4.8h,   v6.h[1]
        mls             v27.8h,     v7.8h,   v6.h[0]

        // --- lowpass_8H v28, v29 ---
        ext             v0.16b,     v28.16b, v28.16b, #2
        ext             v1.16b,     v28.16b, v28.16b, #3
        uaddl           v0.8h,      v0.8b,   v1.8b
        ext             v2.16b,     v28.16b, v28.16b, #1
        ext             v3.16b,     v28.16b, v28.16b, #4
        uaddl           v2.8h,      v2.8b,   v3.8b
        ext             v30.16b,    v28.16b, v28.16b, #5
        uaddl           v28.8h,     v28.8b,  v30.8b
        ext             v4.16b,     v29.16b, v29.16b, #2
        mla             v28.8h,     v0.8h,   v6.h[1]
        ext             v5.16b,     v29.16b, v29.16b, #3
        uaddl           v4.8h,      v4.8b,   v5.8b
        ext             v7.16b,     v29.16b, v29.16b, #1
        mls             v28.8h,     v2.8h,   v6.h[0]
        ext             v0.16b,     v29.16b, v29.16b, #4
        uaddl           v7.8h,      v7.8b,   v0.8b
        ext             v31.16b,    v29.16b, v29.16b, #5
        uaddl           v29.8h,     v29.8b,  v31.8b
        mla             v29.8h,     v4.8h,   v6.h[1]
        mls             v29.8h,     v7.8h,   v6.h[0] // @slothy:ignore_useless_output

        // --- lowpass_8.16 v16,v17,v18,v19,v20,v21 -> v16.8b ---
        // trashes v0-v7; v6 is overwritten here (constants no longer needed)
        saddl           v5.4s,  v18.4h, v19.4h
        saddl2          v1.4s,  v18.8h, v19.8h
        saddl           v6.4s,  v17.4h, v20.4h
        saddl2          v2.4s,  v17.8h, v20.8h
        saddl           v0.4s,  v16.4h, v21.4h
        saddl2          v4.4s,  v16.8h, v21.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v16.8b, v5.8h

        // --- lowpass_8.16 v17,v18,v19,v20,v21,v22 -> v17.8b ---
        saddl           v5.4s,  v19.4h, v20.4h
        saddl2          v1.4s,  v19.8h, v20.8h
        saddl           v6.4s,  v18.4h, v21.4h
        saddl2          v2.4s,  v18.8h, v21.8h
        saddl           v0.4s,  v17.4h, v22.4h
        saddl2          v4.4s,  v17.8h, v22.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v17.8b, v5.8h

        // --- lowpass_8.16 v18,v19,v20,v21,v22,v23 -> v18.8b ---
        saddl           v5.4s,  v20.4h, v21.4h
        saddl2          v1.4s,  v20.8h, v21.8h
        saddl           v6.4s,  v19.4h, v22.4h
        saddl2          v2.4s,  v19.8h, v22.8h
        saddl           v0.4s,  v18.4h, v23.4h
        saddl2          v4.4s,  v18.8h, v23.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v18.8b, v5.8h

        // --- lowpass_8.16 v19,v20,v21,v22,v23,v24 -> v19.8b ---
        saddl           v5.4s,  v21.4h, v22.4h
        saddl2          v1.4s,  v21.8h, v22.8h
        saddl           v6.4s,  v20.4h, v23.4h
        saddl2          v2.4s,  v20.8h, v23.8h
        saddl           v0.4s,  v19.4h, v24.4h
        saddl2          v4.4s,  v19.8h, v24.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v19.8b, v5.8h

        // --- lowpass_8.16 v20,v21,v22,v23,v24,v25 -> v20.8b ---
        saddl           v5.4s,  v22.4h, v23.4h
        saddl2          v1.4s,  v22.8h, v23.8h
        saddl           v6.4s,  v21.4h, v24.4h
        saddl2          v2.4s,  v21.8h, v24.8h
        saddl           v0.4s,  v20.4h, v25.4h
        saddl2          v4.4s,  v20.8h, v25.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v20.8b, v5.8h

        // --- lowpass_8.16 v21,v22,v23,v24,v25,v26 -> v21.8b ---
        saddl           v5.4s,  v23.4h, v24.4h
        saddl2          v1.4s,  v23.8h, v24.8h
        saddl           v6.4s,  v22.4h, v25.4h
        saddl2          v2.4s,  v22.8h, v25.8h
        saddl           v0.4s,  v21.4h, v26.4h
        saddl2          v4.4s,  v21.8h, v26.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v21.8b, v5.8h

        // --- lowpass_8.16 v22,v23,v24,v25,v26,v27 -> v22.8b ---
        saddl           v5.4s,  v24.4h, v25.4h
        saddl2          v1.4s,  v24.8h, v25.8h
        saddl           v6.4s,  v23.4h, v26.4h
        saddl2          v2.4s,  v23.8h, v26.8h
        saddl           v0.4s,  v22.4h, v27.4h
        saddl2          v4.4s,  v22.8h, v27.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v22.8b, v5.8h

        // --- lowpass_8.16 v23,v24,v25,v26,v27,v28 -> v23.8b ---
        saddl           v5.4s,  v25.4h, v26.4h
        saddl2          v1.4s,  v25.8h, v26.8h
        saddl           v6.4s,  v24.4h, v27.4h
        saddl2          v2.4s,  v24.8h, v27.8h
        saddl           v0.4s,  v23.4h, v28.4h
        saddl2          v4.4s,  v23.8h, v28.8h
        shl             v3.4s,  v5.4s,  #4
        shl             v5.4s,  v5.4s,  #2
        shl             v7.4s,  v6.4s,  #2
        add             v5.4s,  v5.4s,  v3.4s
        add             v6.4s,  v6.4s,  v7.4s
        shl             v3.4s,  v1.4s,  #4
        shl             v1.4s,  v1.4s,  #2
        shl             v7.4s,  v2.4s,  #2
        add             v1.4s,  v1.4s,  v3.4s
        add             v2.4s,  v2.4s,  v7.4s
        add             v5.4s,  v5.4s,  v0.4s
        sub             v5.4s,  v5.4s,  v6.4s
        add             v1.4s,  v1.4s,  v4.4s
        sub             v1.4s,  v1.4s,  v2.4s
        rshrn           v5.4h,  v5.4s,  #10
        rshrn2          v5.8h,  v1.4s,  #10
        sqxtun          v23.8b, v5.8h
body_end:

        ret
