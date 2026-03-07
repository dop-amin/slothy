ff_vector_fmul_neon:
1:
        subs            w3,  w3,  #16
        ld1             {v0.4s, v1.4s}, [x1], #32
        ld1             {v2.4s, v3.4s}, [x1], #32
        ld1             {v4.4s, v5.4s}, [x2], #32
        ld1             {v6.4s, v7.4s}, [x2], #32
        fmul            v16.4s, v0.4s,  v4.4s
        fmul            v17.4s, v1.4s,  v5.4s
        fmul            v18.4s, v2.4s,  v6.4s
        fmul            v19.4s, v3.4s,  v7.4s
        st1             {v16.4s, v17.4s}, [x0], #32
        st1             {v18.4s, v19.4s}, [x0], #32
        b.ne            1b
        ret
