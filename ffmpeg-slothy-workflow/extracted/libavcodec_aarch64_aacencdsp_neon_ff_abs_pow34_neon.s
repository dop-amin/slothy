function ff_abs_pow34_neon, export=1

1:

        ld1             {v0.4s}, [x1], #16

        subs            w2, w2, #4

        fabs            v0.4s, v0.4s

        fsqrt           v2.4s, v0.4s

        fmul            v0.4s, v2.4s, v0.4s

        fsqrt           v0.4s, v0.4s

        st1             {v0.4s}, [x0], #16

        b.ne            1b

        ret

endfunc
