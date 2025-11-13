function ff_ps_stereo_interpolate_neon, export=1

        ld1             {v0.4s}, [x2]

        ld1             {v1.4s}, [x3]

        zip1            v4.4s, v0.4s, v0.4s

        zip2            v5.4s, v0.4s, v0.4s

        zip1            v6.4s, v1.4s, v1.4s

        zip2            v7.4s, v1.4s, v1.4s

1:      ld1             {v2.2s}, [x0]

        ld1             {v3.2s}, [x1]

        fadd            v4.4s, v4.4s, v6.4s

        fadd            v5.4s, v5.4s, v7.4s

        mov             v2.d[1], v2.d[0]

        mov             v3.d[1], v3.d[0]

        fmul            v2.4s, v2.4s, v4.4s

        fmla            v2.4s, v3.4s, v5.4s

        st1             {v2.d}[0], [x0], #8

        st1             {v2.d}[1], [x1], #8

        subs            w4, w4, #1

        b.gt            1b

        ret

endfunc
