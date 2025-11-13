function ff_ps_stereo_interpolate_ipdopd_neon, export=1

        ld1             {v0.4s,v1.4s}, [x2]

        ld1             {v6.4s,v7.4s}, [x3]

        fneg            v2.4s, v1.4s

        fneg            v3.4s, v7.4s

        zip1            v16.4s, v0.4s, v0.4s

        zip2            v17.4s, v0.4s, v0.4s

        zip1            v18.4s, v2.4s, v1.4s

        zip2            v19.4s, v2.4s, v1.4s

        zip1            v20.4s, v6.4s, v6.4s

        zip2            v21.4s, v6.4s, v6.4s

        zip1            v22.4s, v3.4s, v7.4s

        zip2            v23.4s, v3.4s, v7.4s

1:      ld1             {v2.2s}, [x0]

        ld1             {v3.2s}, [x1]

        fadd            v16.4s, v16.4s, v20.4s

        fadd            v17.4s, v17.4s, v21.4s

        mov             v2.d[1], v2.d[0]

        mov             v3.d[1], v3.d[0]

        fmul            v4.4s, v2.4s, v16.4s

        fmla            v4.4s, v3.4s, v17.4s

        fadd            v18.4s, v18.4s, v22.4s

        fadd            v19.4s, v19.4s, v23.4s

        ext             v2.16b, v2.16b, v2.16b, #4

        ext             v3.16b, v3.16b, v3.16b, #4

        fmla            v4.4s, v2.4s, v18.4s

        fmla            v4.4s, v3.4s, v19.4s

        st1             {v4.d}[0], [x0], #8

        st1             {v4.d}[1], [x1], #8

        subs            w4, w4, #1

        b.gt            1b

        ret

endfunc
