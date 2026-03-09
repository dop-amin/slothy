.global ff_opus_deemphasis_neon
ff_opus_deemphasis_neon:
        // x0 = dst, x1 = src, w3 = len (multiple of 8)
        // x2 = coeff table (16 floats)
        // v4-v7 = filter coefficients loaded before loop
        // v0 = state vector (carries inter-iteration dependency)
        ld1             {v4.4s}, [x2], #16
        ld1             {v5.4s}, [x2], #16
        ld1             {v6.4s}, [x2], #16
        ld1             {v7.4s}, [x2]
        fmul            v0.4s, v4.4s, v0.s[0]
1:
        ld1             {v1.4s, v2.4s}, [x1], #32
        fmla            v0.4s, v5.4s, v1.s[0]
        fmul            v3.4s, v7.4s, v2.s[2]
        fmla            v0.4s, v6.4s, v1.s[1]
        fmla            v3.4s, v6.4s, v2.s[1]
        fmla            v0.4s, v7.4s, v1.s[2]
        fmla            v3.4s, v5.4s, v2.s[0]
        fadd            v1.4s, v1.4s, v0.4s
        fadd            v2.4s, v2.4s, v3.4s
        fmla            v2.4s, v4.4s, v1.s[3]
        st1             {v1.4s, v2.4s}, [x0], #32
        fmul            v0.4s, v4.4s, v2.s[3]
        subs            w3, w3, #8
        b.gt            1b
        mov             s0, v2.s[3]
        ret
