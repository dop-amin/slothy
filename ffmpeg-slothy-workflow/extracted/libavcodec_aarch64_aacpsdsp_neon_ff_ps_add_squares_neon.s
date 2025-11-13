function ff_ps_add_squares_neon, export=1

1:      ld1             {v0.4s,v1.4s}, [x1], #32

        fmul            v0.4s, v0.4s, v0.4s

        fmul            v1.4s, v1.4s, v1.4s

        faddp           v2.4s, v0.4s, v1.4s

        ld1             {v3.4s}, [x0]

        fadd            v3.4s, v3.4s, v2.4s

        st1             {v3.4s}, [x0], #16

        subs            w2, w2, #4

        b.gt            1b

        ret

endfunc
