.global ff_vector_fmul_add_neon
ff_vector_fmul_add_neon:
        // x0 = dst, x1 = src0, x2 = src1, x3 = src2, w4 = len (multiple of 32)
        // dst[i] = src0[i] * src1[i] + src2[i]
        // Double-unrolled: 32 floats per iteration, 26 instructions in loop body.
1:
        ld1     {v0.4s, v1.4s, v2.4s, v3.4s},     [x1], #64
        ld1     {v4.4s, v5.4s, v6.4s, v7.4s},     [x2], #64
        ld1     {v16.4s, v17.4s, v18.4s, v19.4s}, [x3], #64
        ld1     {v20.4s, v21.4s, v22.4s, v23.4s}, [x1], #64
        ld1     {v24.4s, v25.4s, v26.4s, v27.4s}, [x2], #64
        ld1     {v28.4s, v29.4s, v30.4s, v31.4s}, [x3], #64
        fmul    v0.4s,  v0.4s,  v4.4s
        fmul    v1.4s,  v1.4s,  v5.4s
        fmul    v2.4s,  v2.4s,  v6.4s
        fmul    v3.4s,  v3.4s,  v7.4s
        fmul    v20.4s, v20.4s, v24.4s
        fmul    v21.4s, v21.4s, v25.4s
        fmul    v22.4s, v22.4s, v26.4s
        fmul    v23.4s, v23.4s, v27.4s
        fadd    v0.4s,  v0.4s,  v16.4s
        fadd    v1.4s,  v1.4s,  v17.4s
        fadd    v2.4s,  v2.4s,  v18.4s
        fadd    v3.4s,  v3.4s,  v19.4s
        fadd    v20.4s, v20.4s, v28.4s
        fadd    v21.4s, v21.4s, v29.4s
        fadd    v22.4s, v22.4s, v30.4s
        fadd    v23.4s, v23.4s, v31.4s
        st1     {v0.4s, v1.4s, v2.4s, v3.4s},     [x0], #64
        st1     {v20.4s, v21.4s, v22.4s, v23.4s}, [x0], #64
        subs    w4, w4, #32
        b.ne    1b
        ret
