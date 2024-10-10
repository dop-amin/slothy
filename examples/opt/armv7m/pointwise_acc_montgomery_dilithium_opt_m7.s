.syntax unified
.thumb

.macro montgomery_multiplication res, pa, pb, q, qinv
    smull \pa, \res, \pa, \pb
    mul \pb, \pa, \qinv
    smlal \pa, \res, \pb, \q
.endm

// void asm_pointwise_acc_montgomery(int32_t c[N], const int32_t a[N], const int32_t b[N]);
.global pqcrystals_dilithium_asm_pointwise_acc_montgomery_opt_m7
.type pqcrystals_dilithium_asm_pointwise_acc_montgomery_opt_m7,%function
.align 2
pqcrystals_dilithium_asm_pointwise_acc_montgomery_opt_m7:
    push.w {r4-r11, r14}
    c_ptr .req r0
    a_ptr .req r1
    b_ptr .req r2
    qinv  .req r3
    q     .req r4
    pa0   .req r5
    pa1   .req r6
    pa2   .req r7
    pb0   .req r8
    pb1   .req r9
    pb2   .req r10
    tmp0  .req r11
    ctr   .req r12
    res   .req r14

    movw qinv, #:lower16:0xfc7fdfff
    movt qinv, #:upper16:0xfc7fdfff
    movw q, #0xE001
    movt q, #0x7F


    // 85x3 = 255 coefficients
    movw ctr, #85
    1:
        pointwise_montgomery_acc_start:
                                      // Instructions:    25
                                      // Expected cycles: 16
                                      // Expected IPC:    1.56
                                      //
                                      // Wall time:     0.19s
                                      // User time:     0.19s
                                      //
                                      // ----- cycle (expected) ------>
                                      // 0                        25
                                      // |------------------------|----
        ldr.w r6, [r1, #4]            // *.............................
        ldr.w r10, [r2, #4]           // *.............................
        ldr.w r14, [r2, #8]           // .*............................
        ldr r7, [r2], #12             // .*............................
        smull r8, r10, r6, r10        // ..*...........................
        ldr.w r11, [r1, #8]           // ..*...........................
        ldr r6, [r1], #12             // ...*..........................
        smull r9, r5, r11, r14        // ....*.........................
        subs r12, #1                  // ....*.........................
        smull r11, r6, r6, r7         // .....*........................
        mul r14, r9, r3               // ......*.......................
        mul r7, r11, r3               // .......*......................
        smlal r9, r5, r14, r4         // ........*.....................
        ldr.w r14, [r0]               // ........*.....................
        smlal r11, r6, r7, r4         // .........*....................
        ldr.w r7, [r0, #4]            // .........*....................
        mul r9, r8, r3                // ..........*...................
        ldr.w r11, [r0, #8]           // ..........*...................
        add.w r14, r6, r14            // ...........*..................
        str r14, [r0], #12            // ...........*..................
        add.w r6, r5, r11             // ............*.................
        str r6, [r0, #-4]             // .............*................
        smlal r8, r10, r9, r4         // .............*................
        add.w r7, r10, r7             // ...............*..............
        str r7, [r0, #-8]             // ...............*..............

                                      // ------ cycle (expected) ------>
                                      // 0                        25
                                      // |------------------------|-----
        // ldr.w r6, [r1, #4]         // *..............................
        // ldr.w r7, [r1, #8]         // ..*............................
        // ldr r5, [r1], #12          // ...*...........................
        // ldr.w r9, [r2, #4]         // *..............................
        // ldr.w r10, [r2, #8]        // .*.............................
        // ldr r8, [r2], #12          // .*.............................
        // smull r5, r14, r5, r8      // .....*.........................
        // mul r8, r5, r3             // .......*.......................
        // smlal r5, r14, r8, r4      // .........*.....................
        // smull r6, r5, r6, r9       // ..*............................
        // mul r9, r6, r3             // ..........*....................
        // smlal r6, r5, r9, r4       // .............*.................
        // smull r7, r6, r7, r10      // ....*..........................
        // mul r10, r7, r3            // ......*........................
        // smlal r7, r6, r10, r4      // ........*......................
        // ldr.w r8, [r0]             // ........*......................
        // ldr.w r9, [r0, #4]         // .........*.....................
        // ldr.w r10, [r0, #8]        // ..........*....................
        // add.w r14, r14, r8         // ...........*...................
        // str r14, [r0], #12         // ...........*...................
        // add.w r5, r5, r9           // ...............*...............
        // str r5, [r0, #-8]          // ...............*...............
        // add.w r6, r6, r10          // ............*..................
        // str r6, [r0, #-4]          // .............*.................
        // subs r12, #1               // ....*..........................

        pointwise_montgomery_acc_end:

    bne.w 1b

    // final coefficient
    ldr.w pa0, [a_ptr]
    ldr.w pb0, [b_ptr]
    ldr.w pa1, [c_ptr]
    montgomery_multiplication res, pa0, pb0, q, qinv
    add.w res, res, pa1
    str.w res, [c_ptr]

    pop.w {r4-r11, pc}
