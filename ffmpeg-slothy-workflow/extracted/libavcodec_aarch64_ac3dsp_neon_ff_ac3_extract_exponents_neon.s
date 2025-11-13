function ff_ac3_extract_exponents_neon, export=1

        movi            v1.4s, #8

1:      ld1             {v0.4s}, [x1], #16

        abs             v0.4s, v0.4s

        clz             v0.4s, v0.4s

        sub             v0.4s, v0.4s, v1.4s

        xtn             v0.4h, v0.4s

        xtn             v0.8b, v0.8h

        st1             {v0.s}[0], [x0], #4

        subs            w2, w2, #4

        b.gt            1b

        ret

endfunc
