.global ff_hevc_put_hevc_h16_8_neon
ff_hevc_put_hevc_h16_8_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h26x/qpel_neon.S
// function ff_hevc_put_hevc_h16_8_neon (export=0)
// Called via bl by ff_hevc_put_hevc_qpel_h12/h16/h32..._8_neon
//
// Registers on entry (set by caller):
//   v0.8h  = 8 signed 16-bit filter coefficients
//   v16.8h = src row 0, pixels [0..7]  (already uxtl'd by caller)
//   v17.8b = src row 0, pixels [8..15] (still 8b, uxtl'd here)
//   v18.8b = src row 0, pixels [16..23] (still 8b, uxtl'd here)
//   v19.8h = src row 1, pixels [0..7]  (already uxtl'd by caller)
//   v20.8b = src row 1, pixels [8..15] (still 8b, uxtl'd here)
//   v21.8b = src row 1, pixels [16..23] (still 8b, uxtl'd here)
// Outputs:
//   v26.8h = filtered pixels [0..7],  row 0
//   v27.8h = filtered pixels [8..15], row 0
//   v28.8h = filtered pixels [0..7],  row 1
//   v29.8h = filtered pixels [8..15], row 1
// Clobbers: v22, v23, v24, v25

body_start:
        uxtl            v17.8h,  v17.8b
        uxtl            v18.8h,  v18.8b
        uxtl            v20.8h,  v20.8b
        uxtl            v21.8h,  v21.8b

        mul             v26.8h,  v16.8h, v0.h[0]
        mul             v27.8h,  v17.8h, v0.h[0]
        mul             v28.8h,  v19.8h, v0.h[0]
        mul             v29.8h,  v20.8h, v0.h[0]

        ext             v22.16b, v16.16b, v17.16b, #2
        ext             v23.16b, v17.16b, v18.16b, #2
        ext             v24.16b, v19.16b, v20.16b, #2
        ext             v25.16b, v20.16b, v21.16b, #2
        mla             v26.8h,  v22.8h, v0.h[1]
        mla             v27.8h,  v23.8h, v0.h[1]
        mla             v28.8h,  v24.8h, v0.h[1]
        mla             v29.8h,  v25.8h, v0.h[1]

        ext             v22.16b, v16.16b, v17.16b, #4
        ext             v23.16b, v17.16b, v18.16b, #4
        ext             v24.16b, v19.16b, v20.16b, #4
        ext             v25.16b, v20.16b, v21.16b, #4
        mla             v26.8h,  v22.8h, v0.h[2]
        mla             v27.8h,  v23.8h, v0.h[2]
        mla             v28.8h,  v24.8h, v0.h[2]
        mla             v29.8h,  v25.8h, v0.h[2]

        ext             v22.16b, v16.16b, v17.16b, #6
        ext             v23.16b, v17.16b, v18.16b, #6
        ext             v24.16b, v19.16b, v20.16b, #6
        ext             v25.16b, v20.16b, v21.16b, #6
        mla             v26.8h,  v22.8h, v0.h[3]
        mla             v27.8h,  v23.8h, v0.h[3]
        mla             v28.8h,  v24.8h, v0.h[3]
        mla             v29.8h,  v25.8h, v0.h[3]

        ext             v22.16b, v16.16b, v17.16b, #8
        ext             v23.16b, v17.16b, v18.16b, #8
        ext             v24.16b, v19.16b, v20.16b, #8
        ext             v25.16b, v20.16b, v21.16b, #8
        mla             v26.8h,  v22.8h, v0.h[4]
        mla             v27.8h,  v23.8h, v0.h[4]
        mla             v28.8h,  v24.8h, v0.h[4]
        mla             v29.8h,  v25.8h, v0.h[4]

        ext             v22.16b, v16.16b, v17.16b, #10
        ext             v23.16b, v17.16b, v18.16b, #10
        ext             v24.16b, v19.16b, v20.16b, #10
        ext             v25.16b, v20.16b, v21.16b, #10
        mla             v26.8h,  v22.8h, v0.h[5]
        mla             v27.8h,  v23.8h, v0.h[5]
        mla             v28.8h,  v24.8h, v0.h[5]
        mla             v29.8h,  v25.8h, v0.h[5]

        ext             v22.16b, v16.16b, v17.16b, #12
        ext             v23.16b, v17.16b, v18.16b, #12
        ext             v24.16b, v19.16b, v20.16b, #12
        ext             v25.16b, v20.16b, v21.16b, #12
        mla             v26.8h,  v22.8h, v0.h[6]
        mla             v27.8h,  v23.8h, v0.h[6]
        mla             v28.8h,  v24.8h, v0.h[6]
        mla             v29.8h,  v25.8h, v0.h[6]

        ext             v22.16b, v16.16b, v17.16b, #14
        ext             v23.16b, v17.16b, v18.16b, #14
        ext             v24.16b, v19.16b, v20.16b, #14
        ext             v25.16b, v20.16b, v21.16b, #14
        mla             v26.8h,  v22.8h, v0.h[7]
        mla             v27.8h,  v23.8h, v0.h[7]
        mla             v28.8h,  v24.8h, v0.h[7]
        mla             v29.8h,  v25.8h, v0.h[7]
body_end:

        ret
