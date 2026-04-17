.global ff_hevc_put_hevc_h8_8_neon
ff_hevc_put_hevc_h8_8_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h26x/qpel_neon.S
// function ff_hevc_put_hevc_h8_8_neon (export=0)
// Called via bl by ff_hevc_put_hevc_qpel_h8_8_neon (and h6, h12 variants)
//
// Registers on entry (set by caller):
//   v0.8h  = 8 signed 16-bit filter coefficients
//   v16.8b = src row 0, bytes [0..7]    (the 8 pixels to filter)
//   v17.8b = src row 0, bytes [8..15]   (continuation, for shifted taps)
//   v18.8b = src row 1, bytes [0..7]
//   v19.8b = src row 1, bytes [8..15]
// Outputs:
//   v23.8h = 8-tap filtered result, row 0 (16-bit)
//   v24.8h = 8-tap filtered result, row 1 (16-bit)
// Clobbers: v20, v21

body_start:
        uxtl            v16.8h,  v16.8b
        uxtl            v17.8h,  v17.8b
        uxtl            v18.8h,  v18.8b
        uxtl            v19.8h,  v19.8b

        mul             v23.8h,  v16.8h, v0.h[0]
        mul             v24.8h,  v18.8h, v0.h[0]

        ext             v20.16b, v16.16b, v17.16b, #2
        ext             v21.16b, v18.16b, v19.16b, #2
        mla             v23.8h,  v20.8h, v0.h[1]
        mla             v24.8h,  v21.8h, v0.h[1]

        ext             v20.16b, v16.16b, v17.16b, #4
        ext             v21.16b, v18.16b, v19.16b, #4
        mla             v23.8h,  v20.8h, v0.h[2]
        mla             v24.8h,  v21.8h, v0.h[2]

        ext             v20.16b, v16.16b, v17.16b, #6
        ext             v21.16b, v18.16b, v19.16b, #6
        mla             v23.8h,  v20.8h, v0.h[3]
        mla             v24.8h,  v21.8h, v0.h[3]

        ext             v20.16b, v16.16b, v17.16b, #8
        ext             v21.16b, v18.16b, v19.16b, #8
        mla             v23.8h,  v20.8h, v0.h[4]
        mla             v24.8h,  v21.8h, v0.h[4]

        ext             v20.16b, v16.16b, v17.16b, #10
        ext             v21.16b, v18.16b, v19.16b, #10
        mla             v23.8h,  v20.8h, v0.h[5]
        mla             v24.8h,  v21.8h, v0.h[5]

        ext             v20.16b, v16.16b, v17.16b, #12
        ext             v21.16b, v18.16b, v19.16b, #12
        mla             v23.8h,  v20.8h, v0.h[6]
        mla             v24.8h,  v21.8h, v0.h[6]

        ext             v20.16b, v16.16b, v17.16b, #14
        ext             v21.16b, v18.16b, v19.16b, #14
        mla             v23.8h,  v20.8h, v0.h[7]
        mla             v24.8h,  v21.8h, v0.h[7]
body_end:

        ret
