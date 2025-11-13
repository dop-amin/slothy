function ff_ac3_sum_square_butterfly_int32_neon, export=1

        movi            v0.2d, #0

        movi            v1.2d, #0

        movi            v2.2d, #0

1:      ld1             {v4.2s}, [x1], #8

        ld1             {v5.2s}, [x2], #8

        subs            w3, w3, #2

        smlal           v0.2d, v4.2s, v4.2s // sum of a^2

        smlal           v1.2d, v5.2s, v5.2s // sum of b^2

        sqdmlal         v2.2d, v4.2s, v5.2s // sum of 2ab

        b.gt            1b

        addp            d0, v0.2d

        addp            d1, v1.2d

        addp            d2, v2.2d

        sub             d3, d0, d2 // a^2 + b^2 - 2ab

        add             d2, d0, d2

        add             d3, d3, d1 // a^2 + b^2 + 2ab

        add             d2, d2, d1

        st1             {v0.1d-v3.1d}, [x0]

        ret

endfunc
