function ff_int32_to_float_fmul_array8_neon, export=1

        lsr             w4,  w4,  #3

        subs            w5,  w4,  #1

        b.eq            1f

2:

        ld1             {v0.4s,v1.4s}, [x2], #32

        ld1             {v2.4s,v3.4s}, [x2], #32

        scvtf           v0.4s,  v0.4s

        scvtf           v1.4s,  v1.4s

        ld1             {v16.2s},  [x3], #8

        scvtf           v2.4s,  v2.4s

        scvtf           v3.4s,  v3.4s

        fmul            v4.4s,  v0.4s,  v16.s[0]

        fmul            v5.4s,  v1.4s,  v16.s[0]

        fmul            v6.4s,  v2.4s,  v16.s[1]

        fmul            v7.4s,  v3.4s,  v16.s[1]

        st1             {v4.4s,v5.4s}, [x1], #32

        st1             {v6.4s,v7.4s}, [x1], #32

        subs            w5,  w5,  #2

        b.gt            2b

        b.eq            1f

        ret

1:

        ld1             {v0.4s,v1.4s}, [x2]

        ld1             {v16.s}[0],  [x3]

        scvtf           v0.4s,  v0.4s

        scvtf           v1.4s,  v1.4s

        fmul            v4.4s,  v0.4s,  v16.s[0]

        fmul            v5.4s,  v1.4s,  v16.s[0]

        st1             {v4.4s,v5.4s}, [x1]

        ret

endfunc
