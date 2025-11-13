function ff_ac3_sum_square_butterfly_float_neon, export=1

        movi            v0.4s, #0

        movi            v1.4s, #0

        movi            v2.4s, #0

        movi            v3.4s, #0

1:      ld1             {v30.4s}, [x1], #16

        ld1             {v31.4s}, [x2], #16

        fadd            v16.4s, v30.4s, v31.4s

        fsub            v17.4s, v30.4s, v31.4s

        fmla            v0.4s, v30.4s, v30.4s

        fmla            v1.4s, v31.4s, v31.4s

        fmla            v2.4s, v16.4s, v16.4s

        fmla            v3.4s, v17.4s, v17.4s

        subs            w3, w3, #4

        b.gt            1b

        faddp           v0.4s, v0.4s, v1.4s

        faddp           v2.4s, v2.4s, v3.4s

        faddp           v0.4s, v0.4s, v2.4s

        st1             {v0.4s}, [x0]

        ret

endfunc
