function ff_int32_to_float_fmul_scalar_neon, export=1

        ld1             {v1.4s,v2.4s}, [x1], #32

        scvtf           v1.4s,  v1.4s

        scvtf           v2.4s,  v2.4s

1:

        subs            w2,  w2,  #8

        fmul            v3.4s,  v1.4s,  v0.s[0]

        fmul            v4.4s,  v2.4s,  v0.s[0]

        b.le            2f

        ld1             {v1.4s,v2.4s}, [x1], #32

        st1             {v3.4s,v4.4s}, [x0], #32

        scvtf           v1.4s,  v1.4s

        scvtf           v2.4s,  v2.4s

        b               1b

2:

        st1             {v3.4s,v4.4s}, [x0]

        ret

endfunc
