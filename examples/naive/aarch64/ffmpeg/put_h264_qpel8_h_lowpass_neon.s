.global put_h264_qpel8_h_lowpass_neon
put_h264_qpel8_h_lowpass_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264qpel_neon.S
// function put_h264_qpel8_h_lowpass_neon  (h264_qpel_h_lowpass put)
//
// x0 = dst,  x3 = dst_stride
// x1 = src,  x2 = src_stride
// x12 = height (loop counter, decremented by 2 each iteration)
// v6.h[0]=5, v6.h[1]=20  -- lowpass_const, set by caller

        // v6.h[1]=20, v6.h[0]=5 are set by the caller via lowpass_const.
        // Initialized in the SLOTHY selftest config.

loop_start:
        ld1             {v28.8b, v29.8b}, [x1], x2
        ld1             {v16.8b, v17.8b}, [x1], x2
        subs            x12, x12, #2

        // lowpass_8 v28, v29, v16, v17, v28, v16
        // trashes v0-v5; d0=v28, d1=v16
        ext             v2.8b,  v28.8b, v29.8b, #2
        ext             v3.8b,  v28.8b, v29.8b, #3
        uaddl           v2.8h,  v2.8b,  v3.8b
        ext             v4.8b,  v28.8b, v29.8b, #1
        ext             v5.8b,  v28.8b, v29.8b, #4
        uaddl           v4.8h,  v4.8b,  v5.8b
        ext             v1.8b,  v28.8b, v29.8b, #5
        uaddl           v28.8h, v28.8b, v1.8b
        ext             v0.8b,  v16.8b, v17.8b, #2
        mla             v28.8h, v2.8h,  v6.h[1]
        ext             v1.8b,  v16.8b, v17.8b, #3
        uaddl           v0.8h,  v0.8b,  v1.8b
        ext             v1.8b,  v16.8b, v17.8b, #1
        mls             v28.8h, v4.8h,  v6.h[0]
        ext             v3.8b,  v16.8b, v17.8b, #4
        uaddl           v1.8h,  v1.8b,  v3.8b
        ext             v2.8b,  v16.8b, v17.8b, #5
        uaddl           v16.8h, v16.8b, v2.8b
        mla             v16.8h, v0.8h,  v6.h[1]
        mls             v16.8h, v1.8h,  v6.h[0]
        sqrshrun        v28.8b, v28.8h, #5
        sqrshrun        v16.8b, v16.8h, #5

        st1             {v28.8b}, [x0], x3
        st1             {v16.8b}, [x0], x3
        b.ne            loop_start

        ret
