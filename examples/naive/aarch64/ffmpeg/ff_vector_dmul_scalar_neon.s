.global ff_vector_dmul_scalar_neon
ff_vector_dmul_scalar_neon:
        dup             v16.2d, v0.d[0]
        ld1             {v0.2d, v1.2d}, [x1], #32
1:
        subs            w2,  w2,  #8
        fmul            v0.2d,  v0.2d,  v16.2d
        ld1             {v2.2d, v3.2d}, [x1], #32
        fmul            v1.2d,  v1.2d,  v16.2d
        fmul            v2.2d,  v2.2d,  v16.2d
        st1             {v0.2d, v1.2d}, [x0], #32
        fmul            v3.2d,  v3.2d,  v16.2d
        ld1             {v0.2d, v1.2d}, [x1], #32
        st1             {v2.2d, v3.2d}, [x0], #32
        b.gt            1b
        ret
