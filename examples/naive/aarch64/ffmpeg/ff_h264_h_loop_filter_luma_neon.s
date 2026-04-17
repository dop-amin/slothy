.global ff_h264_h_loop_filter_luma_neon
ff_h264_h_loop_filter_luma_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264dsp_neon.S
// function ff_h264_h_loop_filter_luma_neon
//
// x0 = pix (uint8_t*, stride x1)
// x1 = stride
// w2 = alpha
// w3 = beta
// x4 = tc0 (int8_t[4])
//
// Optimization regions:
//   region1: loads + transpose_8x16B + h264_loop_filter_luma up to (not including) cbz
//   region2: h264_loop_filter_luma after cbz + transpose_4x16B + stores

// h264_loop_filter_start
        cmp             w2,  #0
        ldr             w6,  [x4]
        ccmp            w3,  #0, #0, ne
        mov             v24.s[0], w6
        and             w8,  w6,  w6,  lsl #16
        b.eq            1f
        ands            w8,  w8,  w8,  lsl #8
        b.ge            2f
1:
        ret
2:

region1_start:
        sub             x0,  x0,  #4
        ld1             {v6.8b},    [x0], x1
        ld1             {v20.8b},   [x0], x1
        ld1             {v18.8b},   [x0], x1
        ld1             {v16.8b},   [x0], x1
        ld1             {v0.8b},    [x0], x1
        ld1             {v2.8b},    [x0], x1
        ld1             {v4.8b},    [x0], x1
        ld1             {v26.8b},   [x0], x1
        ld1             {v6.d}[1],  [x0], x1
        ld1             {v20.d}[1], [x0], x1
        ld1             {v18.d}[1], [x0], x1
        ld1             {v16.d}[1], [x0], x1
        ld1             {v0.d}[1],  [x0], x1
        ld1             {v2.d}[1],  [x0], x1
        ld1             {v4.d}[1],  [x0], x1
        ld1             {v26.d}[1], [x0], x1

// transpose_8x16B v6, v20, v18, v16, v0, v2, v4, v26, v21, v23
        trn1            v21.16b, v6.16b,  v20.16b
        trn2            v23.16b, v6.16b,  v20.16b
        trn1            v20.16b, v18.16b, v16.16b
        trn2            v16.16b, v18.16b, v16.16b
        trn1            v6.16b,  v0.16b,  v2.16b
        trn2            v2.16b,  v0.16b,  v2.16b
        trn1            v18.16b, v4.16b,  v26.16b
        trn2            v26.16b, v4.16b,  v26.16b
        trn1            v0.8h,   v6.8h,   v18.8h
        trn2            v18.8h,  v6.8h,   v18.8h
        trn1            v4.8h,   v2.8h,   v26.8h
        trn2            v26.8h,  v2.8h,   v26.8h
        trn1            v2.8h,   v23.8h,  v16.8h
        trn2            v23.8h,  v23.8h,  v16.8h
        trn1            v16.8h,  v21.8h,  v20.8h
        trn2            v21.8h,  v21.8h,  v20.8h
        trn1            v6.4s,   v16.4s,  v0.4s   // @slothy:ignore_useless_output
        trn2            v0.4s,   v16.4s,  v0.4s
        trn1            v20.4s,  v2.4s,   v4.4s
        trn2            v2.4s,   v2.4s,   v4.4s
        trn2            v4.4s,   v21.4s,  v18.4s
        trn1            v18.4s,  v21.4s,  v18.4s
        trn1            v16.4s,  v23.4s,  v26.4s
        trn2            v26.4s,  v23.4s,  v26.4s  // @slothy:ignore_useless_output

// h264_loop_filter_luma first part (before cbz)
// After transpose: v6=p3, v20=p2, v18=p1, v16=p0, v0=q0, v2=q1, v4=q2, v26=q3
        dup             v22.16b, w2                     // alpha
        uxtl            v24.8h,  v24.8b
        uabd            v21.16b, v16.16b, v0.16b        // abs(p0 - q0)
        uxtl            v24.4s,  v24.4h
        uabd            v28.16b, v18.16b, v16.16b       // abs(p1 - p0)
        sli             v24.8h,  v24.8h,  #8
        uabd            v30.16b, v2.16b,  v0.16b        // abs(q1 - q0)
        sli             v24.4s,  v24.4s,  #16
        cmhi            v21.16b, v22.16b, v21.16b       // < alpha
        dup             v22.16b, w3                     // beta
        cmlt            v23.16b, v24.16b, #0
        cmhi            v28.16b, v22.16b, v28.16b       // < beta
        cmhi            v30.16b, v22.16b, v30.16b       // < beta
        bic             v21.16b, v21.16b, v23.16b
        uabd            v17.16b, v20.16b, v16.16b       // abs(p2 - p0)
        and             v21.16b, v21.16b, v28.16b
        uabd            v19.16b,  v4.16b,  v0.16b       // abs(q2 - q0)
        and             v21.16b, v21.16b, v30.16b       // < beta
        shrn            v30.8b,  v21.8h,  #4
        mov             x7, v30.d[0]
        cmhi            v17.16b, v22.16b, v17.16b       // < beta
        cmhi            v19.16b, v22.16b, v19.16b       // < beta
region1_end:

        cbz             x7,  9f

region2_start:
// h264_loop_filter_luma second part (after cbz)
        and             v17.16b, v17.16b, v21.16b
        and             v19.16b, v19.16b, v21.16b
        and             v24.16b, v24.16b, v21.16b
        urhadd          v28.16b, v16.16b,  v0.16b
        sub             v21.16b, v24.16b, v17.16b
        uqadd           v23.16b, v18.16b, v24.16b
        uhadd           v20.16b, v20.16b, v28.16b
        sub             v21.16b, v21.16b, v19.16b
        uhadd           v28.16b,  v4.16b, v28.16b
        umin            v23.16b, v23.16b, v20.16b
        uqsub           v22.16b, v18.16b, v24.16b
        uqadd           v4.16b,   v2.16b, v24.16b
        umax            v23.16b, v23.16b, v22.16b
        uqsub           v22.16b,  v2.16b, v24.16b
        umin            v28.16b,  v4.16b, v28.16b
        uxtl            v4.8h,    v0.8b
        umax            v28.16b, v28.16b, v22.16b
        uxtl2           v20.8h,   v0.16b
        usubw           v4.8h,    v4.8h,  v16.8b
        usubw2          v20.8h,  v20.8h,  v16.16b
        shl             v4.8h,    v4.8h,  #2
        shl             v20.8h,  v20.8h,  #2
        uaddw           v4.8h,    v4.8h,  v18.8b
        uaddw2          v20.8h,  v20.8h,  v18.16b
        usubw           v4.8h,    v4.8h,   v2.8b
        usubw2          v20.8h,  v20.8h,   v2.16b
        rshrn           v4.8b,    v4.8h,  #3
        rshrn2          v4.16b,  v20.8h,  #3
        bsl             v17.16b, v23.16b, v18.16b
        bsl             v19.16b, v28.16b,  v2.16b
        neg             v23.16b, v21.16b
        uxtl            v28.8h,  v16.8b
        smin            v4.16b,   v4.16b, v21.16b
        uxtl2           v21.8h,  v16.16b
        smax            v4.16b,   v4.16b, v23.16b
        uxtl            v22.8h,   v0.8b
        uxtl2           v24.8h,   v0.16b
        saddw           v28.8h,  v28.8h,  v4.8b
        saddw2          v21.8h,  v21.8h,  v4.16b
        ssubw           v22.8h,  v22.8h,  v4.8b
        ssubw2          v24.8h,  v24.8h,  v4.16b
        sqxtun          v16.8b,  v28.8h
        sqxtun2         v16.16b, v21.8h
        sqxtun          v0.8b,   v22.8h
        sqxtun2         v0.16b,  v24.8h

// transpose_4x16B v17, v16, v0, v19, v21, v23, v25, v27
        trn1            v21.16b, v17.16b, v16.16b
        trn2            v23.16b, v17.16b, v16.16b
        trn1            v25.16b, v0.16b,  v19.16b
        trn2            v27.16b, v0.16b,  v19.16b
        trn1            v17.8h,  v21.8h,  v25.8h
        trn2            v0.8h,   v21.8h,  v25.8h
        trn1            v16.8h,  v23.8h,  v27.8h
        trn2            v19.8h,  v23.8h,  v27.8h

        sub             x0,  x0,  x1, lsl #4
        add             x0,  x0,  #2
        st1             {v17.s}[0], [x0], x1
        st1             {v16.s}[0], [x0], x1
        st1             {v0.s}[0],  [x0], x1
        st1             {v19.s}[0], [x0], x1
        st1             {v17.s}[1], [x0], x1
        st1             {v16.s}[1], [x0], x1
        st1             {v0.s}[1],  [x0], x1
        st1             {v19.s}[1], [x0], x1
        st1             {v17.s}[2], [x0], x1
        st1             {v16.s}[2], [x0], x1
        st1             {v0.s}[2],  [x0], x1
        st1             {v19.s}[2], [x0], x1
        st1             {v17.s}[3], [x0], x1
        st1             {v16.s}[3], [x0], x1
        st1             {v0.s}[3],  [x0], x1
        st1             {v19.s}[3], [x0], x1  // @slothy:ignore_useless_output
region2_end:
9:
        ret
