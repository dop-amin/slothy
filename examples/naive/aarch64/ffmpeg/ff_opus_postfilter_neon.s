.global ff_opus_postfilter_neon
ff_opus_postfilter_neon:
        // x0 = dst, x1 = pitch buf (x1 = x1-period-2), x3 = len
        // x4 = x0-period-1, x5 = x0, x6 = x0+period
        // v0 = gains[0] dup, v1 = gains[1] dup, v2 = gains[2] dup
        // v3 = running fmla accumulator (seed from prev iter fmul)
        ld1             {v0.4s}, [x2]
        sub             x5, x0, w1, sxtw #2
        sub             x1, x5, #8
        dup             v1.4s, v0.s[1]
        dup             v2.4s, v0.s[2]
        dup             v0.4s, v0.s[0]
        ld1             {v3.4s}, [x1], #16
        sub             x4, x5, #4
        add             x6, x5, #4
        fmul            v3.4s, v3.4s, v2.4s
1:
        ld1             {v7.4s}, [x1], #16
        ld1             {v4.4s}, [x4], #16
        fmla            v3.4s, v7.4s, v2.4s
        ld1             {v6.4s}, [x6], #16
        ld1             {v5.4s}, [x5], #16
        fadd            v6.4s, v6.4s, v4.4s
        fmla            v3.4s, v5.4s, v0.4s
        ld1             {v4.4s}, [x0]
        fmla            v3.4s, v6.4s, v1.4s
        fadd            v4.4s, v4.4s, v3.4s
        fmul            v3.4s, v7.4s, v2.4s
        st1             {v4.4s}, [x0], #16
        subs            w3, w3, #4
        b.gt            1b
        ret
