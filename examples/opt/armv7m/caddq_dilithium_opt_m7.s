.syntax unified
.thumb

.macro caddq a, tmp, q
    and     \tmp, \q, \a, asr #31
    add     \a, \a, \tmp
.endm

// void asm_caddq(int32_t a[N]);
.global pqcrystals_dilithium_asm_caddq_opt_m7
.type pqcrystals_dilithium_asm_caddq_opt_m7, %function
.align 2
pqcrystals_dilithium_asm_caddq_opt_m7:
    push {r4-r11, r14}

    movw r12,#:lower16:8380417
    movt r12,#:upper16:8380417

    movw r10, #32
                // Instructions:    0
                // Expected cycles: 0
                // Expected IPC:    0.00
                //
                // Wall time:     0.00s
                // User time:     0.00s
                //
1:
                                          // Instructions:    33
                                          // Expected cycles: 17
                                          // Expected IPC:    1.94
                                          //
                                          // Wall time:     3.57s
                                          // User time:     3.57s
                                          //
                                          // ----- cycle (expected) ------>
                                          // 0                        25
                                          // |------------------------|----
        ldr.w r9, [r0]                    // *.............................
        ldr.w r2, [r0, #28]               // *.............................
        ldr.w r11, [r0, #24]              // .*............................
        ldr.w r8, [r0, #20]               // .*............................
        subs r10, #1                      // ..*...........................
        ldr.w r7, [r0, #4]                // ..*...........................
        and r5, r12, r2, asr #31          // ...*..........................
        ldr.w r3, [r0, #16]               // ...*..........................
        add r4, r2, r5                    // ....*.........................
        str.w r4, [r0, #28]               // ....*.........................
        ldr.w r5, [r0, #12]               // .....*........................
        and r14, r12, r11, asr #31        // .....*........................
        add r11, r11, r14                 // ......*.......................
        and r14, r12, r3, asr #31         // ......*.......................
        add r2, r3, r14                   // .......*......................
        and r3, r12, r9, asr #31          // .......*......................
        add r3, r9, r3                    // ........*.....................
        str.w r2, [r0, #16]               // ........*.....................
        ldr.w r14, [r0, #8]               // .........*....................
        and r6, r12, r5, asr #31          // .........*....................
        and r2, r12, r8, asr #31          // ..........*...................
        add r4, r5, r6                    // ..........*...................
        add r6, r8, r2                    // ...........*..................
        str.w r6, [r0, #20]               // ...........*..................
        and r9, r12, r14, asr #31         // ............*.................
        str r3, [r0], #8*4                // ............*.................
        add r6, r14, r9                   // .............*................
        str r11, [r0, #-8]                // .............*................
        and r11, r12, r7, asr #31         // ..............*...............
        str r6, [r0, #-24]                // ..............*...............
        add r6, r7, r11                   // ...............*..............
        str r6, [r0, #-28]                // ...............*..............
        str r4, [r0, #-20]                // ................*.............

                                             // ------ cycle (expected) ------>
                                             // 0                        25
                                             // |------------------------|-----
        // ldr.w r1, [r0]                    // *................~.............
        // ldr.w r2, [r0, #1*4]              // ..*..............'.~...........
        // ldr.w r3, [r0, #2*4]              // .........*.......'........~....
        // ldr.w r4, [r0, #3*4]              // .....*...........'....~........
        // ldr.w r5, [r0, #4*4]              // ...*.............'..~..........
        // ldr.w r6, [r0, #5*4]              // .*...............'~............
        // ldr.w r7, [r0, #6*4]              // .*...............'~............
        // ldr.w r8, [r0, #7*4]              // *................~.............
        // and     r9, r12, r1, asr #31      // .......*.........'......~......
        // add     r1, r1, r9                // ........*........'.......~.....
        // and     r9, r12, r2, asr #31      // ..............*..'.............
        // add     r2, r2, r9                // ...............*.'.............
        // and     r9, r12, r3, asr #31      // ............*....'...........~.
        // add     r3, r3, r9                // .............*...'.............
        // and     r9, r12, r4, asr #31      // .........*.......'........~....
        // add     r4, r4, r9                // ..........*......'.........~...
        // and     r9, r12, r5, asr #31      // ......*..........'.....~.......
        // add     r5, r5, r9                // .......*.........'......~......
        // and     r9, r12, r6, asr #31      // ..........*......'.........~...
        // add     r6, r6, r9                // ...........*.....'..........~..
        // and     r9, r12, r7, asr #31      // .....*...........'....~........
        // add     r7, r7, r9                // ......*..........'.....~.......
        // and     r9, r12, r8, asr #31      // ...*.............'..~..........
        // add     r8, r8, r9                // ....*............'...~.........
        // str.w r2, [r0, #1*4]              // ...............*.'.............
        // str.w r3, [r0, #2*4]              // ..............*..'.............
        // str.w r4, [r0, #3*4]              // ................*'.............
        // str.w r5, [r0, #4*4]              // ........*........'.......~.....
        // str.w r6, [r0, #5*4]              // ...........*.....'..........~..
        // str.w r7, [r0, #6*4]              // .............*...'.............
        // str.w r8, [r0, #7*4]              // ....*............'...~.........
        // str r1, [r0], #8*4                // ............*....'...........~.
        // subs r10, #1                      // ..*..............'.~...........

        bne 1b
                // Instructions:    0
                // Expected cycles: 0
                // Expected IPC:    0.00
                //
                // Wall time:     0.00s
                // User time:     0.00s
                //

    pop {r4-r11, pc}

.size pqcrystals_dilithium_asm_caddq_opt_m7, .-pqcrystals_dilithium_asm_caddq_opt_m7