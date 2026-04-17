.global ff_scalarproduct_float_neon
ff_scalarproduct_float_neon:
        movi            v2.4s,  #0
1:
        ld1             {v0.4s}, [x0],   #16
        ld1             {v1.4s}, [x1],   #16
        subs            w2,      w2,     #4
        fmla            v2.4s,   v0.4s,  v1.4s
        b.gt            1b
        faddp           v0.4s,   v2.4s,  v2.4s
        faddp           s0,      v0.2s
        ret
