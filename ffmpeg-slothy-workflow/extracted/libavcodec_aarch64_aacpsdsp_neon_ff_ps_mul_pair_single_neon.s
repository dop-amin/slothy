function ff_ps_mul_pair_single_neon, export=1

1:      ld1             {v0.4s,v1.4s}, [x1], #32

        ld1             {v2.4s},       [x2], #16

        zip1            v3.4s, v2.4s, v2.4s

        zip2            v4.4s, v2.4s, v2.4s

        fmul            v0.4s, v0.4s, v3.4s

        fmul            v1.4s, v1.4s, v4.4s

        st1             {v0.4s,v1.4s}, [x0], #32

        subs            w3, w3, #4

        b.gt            1b

        ret

endfunc
