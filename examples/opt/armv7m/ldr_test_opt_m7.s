.equ ddd, 4

        start:
                                  // Instructions:    8
                                  // Expected cycles: 4
                                  // Expected IPC:    2.00
                                  //
                                  // Cycle bound:     4.0
                                  // IPC bound:       2.00
                                  //
                                  // Wall time:     0.08s
                                  // User time:     0.08s
                                  //
                                  // ----- cycle (expected) ------>
                                  // 0                        25
                                  // |------------------------|----
        ldr r7, [r0, #4*6]        // *.............................
        ldr r4, [r0, #4*3]        // *.............................
        ldr r6, [r0, #4*5]        // .*............................
        ldr r5, [r0, #4*4]        // .*............................
        ldr r2, [r0, #4*1]        // ..*...........................
        ldr r3, [r0, #4*2]        // ..*...........................
        ldr r8, [r0, #4*7]        // ...*..........................
        ldr r1, [r0]              // ...*..........................

                                   // ------ cycle (expected) ------>
                                   // 0                        25
                                   // |------------------------|-----
        // ldr r1, [r0]            // ...*...........................
        // ldr r3, [r0, #4*2]      // ..*............................
        // ldr r5, [r0, #4*4]      // .*.............................
        // ldr r7, [r0, #4*6]      // *..............................
        // ldr r2, [r0, #4*1]      // ..*............................
        // ldr r4, [r0, #4*3]      // *..............................
        // ldr r6, [r0, #4*5]      // .*.............................
        // ldr r8, [r0, #4*7]      // ...*...........................

        end:
