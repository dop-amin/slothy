.global ff_put_h264_chroma_mc8_neon
ff_put_h264_chroma_mc8_neon:
// Macro-expanded from FFmpeg/libavcodec/aarch64/h264cmc_neon.S
// function ff_put_h264_chroma_mc8_neon  (h264_chroma_mc8 put, codec=h264)
//
// x0 = dst,  x2 = stride
// x1 = src,  x2 = stride  (same stride for src and dst)
// w3 = height (loop counter)
// w4 = x (fractional pixel x offset, 0-8)
// w5 = y (fractional pixel y offset, 0-8)
//
// Bilinear interpolation coefficients computed from x, y:
//   A = (8-x)*(8-y) + 32 = 64 - 8y - 8x + xy + 32  (stored in v0.8b)
//   B = (8-y)*x           = 8x - xy                 (stored in v1.8b)
//   C = (8-x)*y           = 8y - xy                 (stored in v2.8b)
//   D = x*y                                          (stored in v3.8b)
//
// General (full bilinear) path only.  Preamble outside loop:

        // --- coefficient setup ---
        mul             w7,  w4,  w5            // w7  = x*y
        lsl             w14, w5,  #3            // w14 = 8*y
        lsl             w13, w4,  #3            // w13 = 8*x
        sub             w6,  w14, w7            // w6  = 8y - xy  (C)
        sub             w12, w13, w7            // w12 = 8x - xy  (B)
        sub             w4,  w7,  w13
        sub             w4,  w4,  w14
        add             w4,  w4,  #64           // w4  = 64 - 8x - 8y + xy  (A)

        dup             v0.8b,  w4
        dup             v1.8b,  w12
        dup             v2.8b,  w6
        dup             v3.8b,  w7

        // --- preload first source row ---
        ld1             {v4.8b, v5.8b}, [x1], x2
        ext             v5.8b,  v4.8b,  v5.8b,  #1

        // --- main bilinear loop (processes 2 rows per iteration) ---
loop_start:
        ld1             {v6.8b, v7.8b}, [x1], x2
        umull           v16.8h, v4.8b,  v0.8b
        umlal           v16.8h, v5.8b,  v1.8b
        ext             v7.8b,  v6.8b,  v7.8b,  #1
        ld1             {v4.8b, v5.8b}, [x1], x2
        umlal           v16.8h, v6.8b,  v2.8b
        ext             v5.8b,  v4.8b,  v5.8b,  #1
        umlal           v16.8h, v7.8b,  v3.8b
        umull           v17.8h, v6.8b,  v0.8b
        subs            w3,  w3,  #2
        umlal           v17.8h, v7.8b,  v1.8b
        umlal           v17.8h, v4.8b,  v2.8b
        umlal           v17.8h, v5.8b,  v3.8b
        rshrn           v16.8b, v16.8h, #6
        rshrn           v17.8b, v17.8h, #6
        st1             {v16.8b}, [x0], x2
        st1             {v17.8b}, [x0], x2
        b.gt            loop_start

        ret
