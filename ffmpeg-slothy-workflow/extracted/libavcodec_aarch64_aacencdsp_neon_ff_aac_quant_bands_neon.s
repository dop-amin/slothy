function ff_aac_quant_bands_neon, export=1

        scvtf           s2, w5

        dup             v1.4s, v1.s[0]

        dup             v2.4s, v2.s[0]

        cbz             w4, 0f

        movi            v5.4s, 0x80, lsl #24

.irp signed,1,0

\signed:

        ld1             {v3.4s}, [x2], #16

        subs            w3, w3, #4

        fmul            v3.4s, v3.4s, v0.s[0]

.if \signed

        ld1             {v4.4s}, [x1], #16

.endif

        fadd            v3.4s, v3.4s, v1.4s

.if \signed

        and             v4.16b, v4.16b, v5.16b

.endif

        fmin            v3.4s, v3.4s, v2.4s

.if \signed

        eor             v3.16b, v4.16b, v3.16b

.endif

        fcvtzs          v3.4s, v3.4s

        st1             {v3.4s}, [x0], #16

        b.ne            \signed\()b

        ret

.endr

endfunc
