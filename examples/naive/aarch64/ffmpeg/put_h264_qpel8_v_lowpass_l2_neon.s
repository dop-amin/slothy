.global put_h264_qpel8_v_lowpass_l2_neon
put_h264_qpel8_v_lowpass_l2_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264qpel_neon.S
// function put_h264_qpel8_v_lowpass_l2_neon  (h264_qpel_v_lowpass_l2 put)
//
// x0 = dst,  x3 = dst_stride
// x1 = src,  x3 = src_stride   (same stride for both -- dst_stride == src_stride == x3)
// x12 = src2 (second reference for L2 blend), x2 = src2_stride
// v6.h[0]=5, v6.h[1]=20  -- lowpass_const, set by caller

body_start:
        ld1             {v16.8b}, [x1], x3
        ld1             {v17.8b}, [x1], x3
        ld1             {v18.8b}, [x1], x3
        ld1             {v19.8b}, [x1], x3
        ld1             {v20.8b}, [x1], x3
        ld1             {v21.8b}, [x1], x3
        ld1             {v22.8b}, [x1], x3
        ld1             {v23.8b}, [x1], x3
        ld1             {v24.8b}, [x1], x3
        ld1             {v25.8b}, [x1], x3
        ld1             {v26.8b}, [x1], x3
        ld1             {v27.8b}, [x1], x3
        ld1             {v28.8b}, [x1]

        // lowpass_8_v v16,v17,v18,v19,v20,v21,v22, v16,v17
        uaddl           v2.8h,  v18.8b, v19.8b
        uaddl           v0.8h,  v19.8b, v20.8b
        uaddl           v4.8h,  v17.8b, v20.8b
        uaddl           v1.8h,  v18.8b, v21.8b
        uaddl           v16.8h, v16.8b, v21.8b
        uaddl           v17.8h, v17.8b, v22.8b
        mla             v16.8h, v2.8h,  v6.h[1]
        mls             v16.8h, v4.8h,  v6.h[0]
        mla             v17.8h, v0.8h,  v6.h[1]
        mls             v17.8h, v1.8h,  v6.h[0]
        sqrshrun        v16.8b, v16.8h, #5
        sqrshrun        v17.8b, v17.8h, #5

        // lowpass_8_v v18,v19,v20,v21,v22,v23,v24, v18,v19
        uaddl           v2.8h,  v20.8b, v21.8b
        uaddl           v0.8h,  v21.8b, v22.8b
        uaddl           v4.8h,  v19.8b, v22.8b
        uaddl           v1.8h,  v20.8b, v23.8b
        uaddl           v18.8h, v18.8b, v23.8b
        uaddl           v19.8h, v19.8b, v24.8b
        mla             v18.8h, v2.8h,  v6.h[1]
        mls             v18.8h, v4.8h,  v6.h[0]
        mla             v19.8h, v0.8h,  v6.h[1]
        mls             v19.8h, v1.8h,  v6.h[0]
        sqrshrun        v18.8b, v18.8h, #5
        sqrshrun        v19.8b, v19.8h, #5

        // lowpass_8_v v20,v21,v22,v23,v24,v25,v26, v20,v21
        uaddl           v2.8h,  v22.8b, v23.8b
        uaddl           v0.8h,  v23.8b, v24.8b
        uaddl           v4.8h,  v21.8b, v24.8b
        uaddl           v1.8h,  v22.8b, v25.8b
        uaddl           v20.8h, v20.8b, v25.8b
        uaddl           v21.8h, v21.8b, v26.8b
        mla             v20.8h, v2.8h,  v6.h[1]
        mls             v20.8h, v4.8h,  v6.h[0]
        mla             v21.8h, v0.8h,  v6.h[1]
        mls             v21.8h, v1.8h,  v6.h[0]
        sqrshrun        v20.8b, v20.8h, #5
        sqrshrun        v21.8b, v21.8h, #5

        // lowpass_8_v v22,v23,v24,v25,v26,v27,v28, v22,v23
        uaddl           v2.8h,  v24.8b, v25.8b
        uaddl           v0.8h,  v25.8b, v26.8b
        uaddl           v4.8h,  v23.8b, v26.8b
        uaddl           v1.8h,  v24.8b, v27.8b
        uaddl           v22.8h, v22.8b, v27.8b
        uaddl           v23.8h, v23.8b, v28.8b
        mla             v22.8h, v2.8h,  v6.h[1]
        mls             v22.8h, v4.8h,  v6.h[0]
        mla             v23.8h, v0.8h,  v6.h[1]
        mls             v23.8h, v1.8h,  v6.h[0]
        sqrshrun        v22.8b, v22.8h, #5
        sqrshrun        v23.8b, v23.8h, #5

        // L2 blend: load 8 rows from src2, urhadd with filtered rows
        ld1             {v24.8b}, [x12], x2
        ld1             {v25.8b}, [x12], x2
        ld1             {v26.8b}, [x12], x2
        ld1             {v27.8b}, [x12], x2
        ld1             {v28.8b}, [x12], x2
        urhadd          v16.8b, v24.8b, v16.8b
        urhadd          v17.8b, v25.8b, v17.8b
        ld1             {v29.8b}, [x12], x2
        urhadd          v18.8b, v26.8b, v18.8b
        urhadd          v19.8b, v27.8b, v19.8b
        ld1             {v30.8b}, [x12], x2
        urhadd          v20.8b, v28.8b, v20.8b
        urhadd          v21.8b, v29.8b, v21.8b
        ld1             {v31.8b}, [x12], x2
        urhadd          v22.8b, v30.8b, v22.8b
        urhadd          v23.8b, v31.8b, v23.8b

        st1             {v16.8b}, [x0], x3
        st1             {v17.8b}, [x0], x3
        st1             {v18.8b}, [x0], x3
        st1             {v19.8b}, [x0], x3
        st1             {v20.8b}, [x0], x3
        st1             {v21.8b}, [x0], x3
        st1             {v22.8b}, [x0], x3
        st1             {v23.8b}, [x0], x3
body_end:

        ret
