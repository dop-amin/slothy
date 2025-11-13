function ff_ac3_exponent_min_neon, export=1

        cbz             w1, 3f

1:      ld1             {v0.16b}, [x0]

        mov             w3, w1

        add             x4, x0, #256

2:      ld1             {v1.16b}, [x4]

        umin            v0.16b, v0.16b, v1.16b

        add             x4, x4, #256

        subs            w3, w3, #1

        b.gt            2b

        st1             {v0.16b}, [x0], #16

        subs            w2, w2, #16

        b.gt            1b

3:      ret

endfunc
