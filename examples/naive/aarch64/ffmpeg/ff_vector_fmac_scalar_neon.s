.global ff_vector_fmac_scalar_neon
ff_vector_fmac_scalar_neon:
        mov             x3,  #-32
1:
        subs            w2,  w2,  #16
        ld1             {v16.4s, v17.4s}, [x0], #32
        ld1             {v18.4s, v19.4s}, [x0], x3
        ld1             {v4.4s,  v5.4s},  [x1], #32
        ld1             {v6.4s,  v7.4s},  [x1], #32
        fmla            v16.4s, v4.4s,  v0.s[0]
        fmla            v17.4s, v5.4s,  v0.s[0]
        fmla            v18.4s, v6.4s,  v0.s[0]
        fmla            v19.4s, v7.4s,  v0.s[0]
        st1             {v16.4s, v17.4s}, [x0], #32
        st1             {v18.4s, v19.4s}, [x0], #32
        b.ne            1b
        ret
