ff_butterflies_float_neon:
1:
        ld1             {v0.4s}, [x0]
        ld1             {v1.4s}, [x1]
        subs            w2,  w2,  #4
        fsub            v2.4s,   v0.4s,  v1.4s
        fadd            v3.4s,   v0.4s,  v1.4s
        st1             {v2.4s}, [x1],   #16
        st1             {v3.4s}, [x0],   #16
        b.gt            1b
        ret
