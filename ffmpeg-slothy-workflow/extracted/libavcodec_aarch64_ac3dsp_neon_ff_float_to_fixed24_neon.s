function ff_float_to_fixed24_neon, export=1

1:      ld1             {v0.4s, v1.4s}, [x1], #32

        fcvtzs          v0.4s, v0.4s, #24

        ld1             {v2.4s, v3.4s}, [x1], #32

        fcvtzs          v1.4s, v1.4s, #24

        fcvtzs          v2.4s, v2.4s, #24

        st1             {v0.4s, v1.4s}, [x0], #32

        fcvtzs          v3.4s, v3.4s, #24

        st1             {v2.4s, v3.4s}, [x0], #32

        subs            w2, w2, #16

        b.ne            1b

        ret

endfunc
