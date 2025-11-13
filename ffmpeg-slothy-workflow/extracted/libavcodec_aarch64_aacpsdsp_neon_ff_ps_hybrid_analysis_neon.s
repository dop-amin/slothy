function ff_ps_hybrid_analysis_neon, export=1

        lsl             x3, x3, #3

        ld2             {v0.4s,v1.4s}, [x1], #32

        ld2             {v2.2s,v3.2s}, [x1], #16

        ld1             {v24.2s},      [x1], #8

        ld2             {v4.2s,v5.2s}, [x1], #16

        ld2             {v6.4s,v7.4s}, [x1]

        rev64           v6.4s, v6.4s

        rev64           v7.4s, v7.4s

        ext             v6.16b, v6.16b, v6.16b, #8

        ext             v7.16b, v7.16b, v7.16b, #8

        rev64           v4.2s, v4.2s

        rev64           v5.2s, v5.2s

        mov             v2.d[1], v3.d[0]

        mov             v4.d[1], v5.d[0]

        mov             v5.d[1], v2.d[0]

        mov             v3.d[1], v4.d[0]

        fadd            v16.4s, v0.4s, v6.4s

        fadd            v17.4s, v1.4s, v7.4s

        fsub            v18.4s, v1.4s, v7.4s

        fsub            v19.4s, v0.4s, v6.4s

        fadd            v22.4s, v2.4s, v4.4s

        fsub            v23.4s, v5.4s, v3.4s

        trn1            v20.2d, v22.2d, v23.2d      // {re4+re8, re5+re7, im8-im4, im7-im5}

        trn2            v21.2d, v22.2d, v23.2d      // {im4+im8, im5+im7, re4-re8, re5-re7}

1:      ld2             {v2.4s,v3.4s}, [x2], #32

        ld2             {v4.2s,v5.2s}, [x2], #16

        ld1             {v6.2s},       [x2], #8

        add             x2, x2, #8

        mov             v4.d[1], v5.d[0]

        mov             v6.s[1], v6.s[0]

        fmul            v6.2s, v6.2s, v24.2s

        fmul            v0.4s, v2.4s, v16.4s

        fmul            v1.4s, v2.4s, v17.4s

        fmls            v0.4s, v3.4s, v18.4s

        fmla            v1.4s, v3.4s, v19.4s

        fmla            v0.4s, v4.4s, v20.4s

        fmla            v1.4s, v4.4s, v21.4s

        faddp           v0.4s, v0.4s, v1.4s

        faddp           v0.4s, v0.4s, v0.4s

        fadd            v0.2s, v0.2s, v6.2s

        st1             {v0.2s}, [x0], x3

        subs            w4, w4, #1

        b.gt            1b

        ret

endfunc
