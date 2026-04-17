.global ff_scalarproduct_float_neon
ff_scalarproduct_float_neon:
        movi            v2.4s,  #0
                // Instructions:    0
                // Expected cycles: 0
                // Expected IPC:    0.00
                //
                // Wall time:     0.00s
                // User time:     0.00s
                //
1:
                                         // Instructions:    4
                                         // Expected cycles: 7
                                         // Expected IPC:    0.57
                                         //
                                         // Cycle bound:     2.0
                                         // IPC bound:       2.00
                                         //
                                         // Wall time:     0.04s
                                         // User time:     0.04s
                                         //
                                         // ----- cycle (expected) ------>
                                         // 0                        25
                                         // |------------------------|----
        ld1 {v1.4S}, [x0], #16           // *.............................
        subs w2, w2, #4                  // *............................. // @slothy:id=cmp
        ld1 {v24.4S}, [x1], #16          // ..*...........................
        fmla v2.4S, v1.4S, v24.4S        // ......*.......................

                                                       // ------ cycle (expected) ------>
                                                       // 0                        25
                                                       // |------------------------|-----
        // ld1             {v0.4s}, [x0],   #16        // *......~......~......~......~..
        // ld1             {v1.4s}, [x1],   #16        // ..*....'.~....'.~....'.~....'..
        // subs            w2,      w2,     #4         // *......~......~......~......~..
        // fmla            v2.4s,   v0.4s,  v1.4s      // ......*'.....~'.....~'.....~'..

        b.gt 1b
                // Instructions:    0
                // Expected cycles: 0
                // Expected IPC:    0.00
                //
                // Wall time:     0.00s
                // User time:     0.00s
                //
        faddp           v0.4s,   v2.4s,  v2.4s
        faddp           s0,      v0.2s
        ret
