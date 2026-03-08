ff_vector_fmul_reverse_neon:
        sxtw            x3,  w3
        add             x2,  x2,  x3,  lsl #2
        sub             x2,  x2,  #32
        mov             x4,  #-32
        ld1             {v2.4s, v3.4s},  [x2], x4
        ld1             {v0.4s, v1.4s},  [x1], #32
1:
loop_body:
        subs            x3,  x3,  #8
        rev64           v3.4s,  v3.4s
        rev64           v2.4s,  v2.4s
        ext             v3.16b, v3.16b, v3.16b,  #8
        ext             v2.16b, v2.16b, v2.16b,  #8
        fmul            v16.4s, v0.4s,  v3.4s
        fmul            v17.4s, v1.4s,  v2.4s
loop_body_end:
        b.eq            2f
        ld1             {v2.4s, v3.4s},  [x2], x4
        ld1             {v0.4s, v1.4s},  [x1], #32
        st1             {v16.4s, v17.4s},  [x0], #32
        b               1b
2:
        st1             {v16.4s, v17.4s},  [x0], #32
        ret
