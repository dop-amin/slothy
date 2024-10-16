.syntax unified
.cpu cortex-m4
.thumb

// q locate in the top half of the register
.macro plant_red q, qa, qinv, tmp
 mul \tmp, \tmp, \qinv
 // tmp*qinv mod 2^2n/ 2^n; in high half
 smlatt \tmp, \tmp, \q, \qa
 // result in high half
.endm

.macro doublebasemul_frombytes_asm_acc_32_16 rptr_tmp, rptr, bptr, zeta, poly0, poly1, poly3, res0, tmp, q, qa, qinv
  ldr \poly0, [\bptr], #4
  ldr \res0, [\rptr_tmp], #4

  smulwt \tmp, \zeta, \poly1
 smlabt \tmp, \tmp, \q, \qa
 smlatt \tmp, \poly0, \tmp, \res0
 smlabb \tmp, \poly0, \poly1, \tmp
  plant_red \q, \qa, \qinv, \tmp

  ldr \res0, [\rptr_tmp], #4
  smladx \res0, \poly0, \poly1, \res0
  plant_red \q, \qa, \qinv, \res0

  pkhtb \res0, \res0, \tmp, asr #16
  str \res0, [\rptr], #4

  neg \zeta, \zeta

  ldr \poly0, [\bptr], #4
  ldr \res0, [\rptr_tmp], #4

  smulwt \tmp, \zeta, \poly3
 smlabt \tmp, \tmp, \q, \qa
 smlatt \tmp, \poly0, \tmp, \res0
 smlabb \tmp, \poly0, \poly3, \tmp
  plant_red \q, \qa, \qinv, \tmp

  ldr \res0, [\rptr_tmp], #4
  smladx \res0, \poly0, \poly3, \res0
  plant_red \q, \qa, \qinv, \res0

  pkhtb \res0, \res0, \tmp, asr #16
  str \res0, [\rptr], #4
.endm

// reduce 2 registers
.macro deserialize aptr, tmp, tmp2, tmp3, t0, t1
 ldrb.w \tmp, [\aptr, #2]
 ldrh.w \tmp2, [\aptr, #3]
 ldrb.w \tmp3, [\aptr, #5]
 ldrh.w \t0, [\aptr], #6

 ubfx.w \t1, \t0, #12, #4
 ubfx.w \t0, \t0, #0, #12
 orr \t1, \t1, \tmp, lsl #4
 orr \t0, \t0, \t1, lsl #16
 // tmp is free now
 ubfx.w \t1, \tmp2, #12, #4
 ubfx.w \tmp, \tmp2, #0, #12
 orr \t1, \t1, \tmp3, lsl #4
 orr \t1, \tmp, \t1, lsl #16
.endm

// void frombytes_mul_asm_acc_32_16(int16_t *r, const int16_t *b, const unsigned char *c, const int32_t zetas[64], const int32_t *r_tmp)
.global frombytes_mul_asm_acc_32_16_opt_m7
.type frombytes_mul_asm_acc_32_16_opt_m7, %function
.align 2
frombytes_mul_asm_acc_32_16_opt_m7:
  push {r4-r11, r14}

  rptr     .req r0
  bptr     .req r1
  aptr     .req r2
  zetaptr  .req r3
  t0       .req r4
 t1       .req r5
 tmp      .req r6
 tmp2     .req r7
 tmp3     .req r8
 q        .req r9
 qa       .req r10
 qinv     .req r11
 zeta     .req r12
 ctr      .req r14
  rptr_tmp .req r3

  movw qa, #26632
 movt  q, #3329
 ### qinv=0x6ba8f301
 movw qinv, #62209
 movt qinv, #27560

  ldr.w tmp, [sp, #9*4] // load rptr_tmp from stack
  vmov s1, tmp

  add ctr, tmp, #64*4*4
  1:
        frombytes_mul_asm_acc_32_16_loop_start:
                                          // Instructions:    45
                                          // Expected cycles: 28
                                          // Expected IPC:    1.61
                                          //
                                          // Wall time:     0.97s
                                          // User time:     0.97s
                                          //
                                          // ----- cycle (expected) ------>
                                          // 0                        25
                                          // |------------------------|----
        ldrh.w r6, [r2, #3]               // *.............................
        ldrb.w r7, [r2, #5]               // *.............................
        ldrb.w r4, [r2, #2]               // .*............................
        ldrh.w r8, [r2], #6               // .*............................
        ubfx.w r12, r6, #12, #4           // ..*...........................
        ldr.w r5, [r3], #4                // ..*...........................
        orr r7, r12, r7, lsl #4           // ...*..........................
        ubfx.w r12, r8, #12, #4           // ...*..........................
        ubfx.w r8, r8, #0, #12            // ....*.........................
        orr r4, r12, r4, lsl #4           // ....*.........................
        ubfx.w r6, r6, #0, #12            // .....*........................
        vmov s2, r3                       // .....*........................
        orr r8, r8, r4, lsl #16           // ......*.......................
        vmov r3, s1                       // ......*.......................
        smulwt r12, r5, r8                // .......*......................
        orr r4, r6, r7, lsl #16           // .......*......................
        ldr r7, [r1], #4                  // ........*.....................
        neg r5, r5                        // ........*.....................
        ldr r6, [r3], #4                  // .........*....................
        smlabt r12, r12, r9, r10          // .........*....................
        smulwt r5, r5, r4                 // ..........*...................
        smlatt r12, r7, r12, r6           // ...........*..................
        ldr r6, [r3], #4                  // ...........*..................
        smlabt r5, r5, r9, r10            // ............*.................
        smlabb r12, r7, r8, r12           // .............*................
        smladx r7, r7, r8, r6             // ..............*...............
        ldr r8, [r3], #4                  // ..............*...............
        mul r6, r12, r11                  // ...............*..............
        ldr r12, [r1], #4                 // ...............*..............
        mul r7, r7, r11                   // ................*.............
        smlatt r5, r12, r5, r8            // .................*............
        smlatt r8, r6, r9, r10            // ..................*...........
        ldr r6, [r3], #4                  // ..................*...........
        smlabb r5, r12, r4, r5            // ...................*..........
        smladx r6, r12, r4, r6            // ....................*.........
        mul r5, r5, r11                   // .....................*........
        smlatt r4, r7, r9, r10            // ......................*.......
        mul r7, r6, r11                   // .......................*......
        smlatt r12, r5, r9, r10           // ........................*.....
        pkhtb r4, r4, r8, asr #16         // ........................*.....
        str r4, [r0], #4                  // .........................*....
        smlatt r7, r7, r9, r10            // .........................*....
        vmov s1, r3                       // ..........................*...
        pkhtb r5, r7, r12, asr #16        // ...........................*..
        str r5, [r0], #4                  // ...........................*..

                                          // ------ cycle (expected) ------>
                                          // 0                        25
                                          // |------------------------|-----
        // ldr.w r12, [r3], #4            // ..*............................
        // ldrb.w r6, [r2, #2]            // .*.............................
        // ldrh.w r7, [r2, #3]            // *..............................
        // ldrb.w r8, [r2, #5]            // *..............................
        // ldrh.w r4, [r2], #6            // .*.............................
        // ubfx.w r5, r4, #12, #4         // ...*...........................
        // ubfx.w r4, r4, #0, #12         // ....*..........................
        // orr r5, r5, r6, lsl #4         // ....*..........................
        // orr r4, r4, r5, lsl #16        // ......*........................
        // ubfx.w r5, r7, #12, #4         // ..*............................
        // ubfx.w r6, r7, #0, #12         // .....*.........................
        // orr r5, r5, r8, lsl #4         // ...*...........................
        // orr r5, r6, r5, lsl #16        // .......*.......................
        // vmov s2, r3                    // .....*.........................
        // vmov r3, s1                    // ......*........................
        // ldr r8, [r1], #4               // ........*......................
        // ldr r6, [r3], #4               // .........*.....................
        // smulwt r7, r12, r4             // .......*.......................
        // smlabt r7, r7, r9, r10         // .........*.....................
        // smlatt r7, r8, r7, r6          // ...........*...................
        // smlabb r7, r8, r4, r7          // .............*.................
        // mul r7, r7, r11                // ...............*...............
        // smlatt r7, r7, r9, r10         // ..................*............
        // ldr r6, [r3], #4               // ...........*...................
        // smladx r6, r8, r4, r6          // ..............*................
        // mul r6, r6, r11                // ................*..............
        // smlatt r6, r6, r9, r10         // ......................*........
        // pkhtb r6, r6, r7, asr #16      // ........................*......
        // str r6, [r0], #4               // .........................*.....
        // neg r12, r12                   // ........*......................
        // ldr r8, [r1], #4               // ...............*...............
        // ldr r6, [r3], #4               // ..............*................
        // smulwt r7, r12, r5             // ..........*....................
        // smlabt r7, r7, r9, r10         // ............*..................
        // smlatt r7, r8, r7, r6          // .................*.............
        // smlabb r7, r8, r5, r7          // ...................*...........
        // mul r7, r7, r11                // .....................*.........
        // smlatt r7, r7, r9, r10         // ........................*......
        // ldr r6, [r3], #4               // ..................*............
        // smladx r6, r8, r5, r6          // ....................*..........
        // mul r6, r6, r11                // .......................*.......
        // smlatt r6, r6, r9, r10         // .........................*.....
        // pkhtb r6, r6, r7, asr #16      // ...........................*...
        // str r6, [r0], #4               // ...........................*...
        // vmov s1, r3                    // ..........................*....

        frombytes_mul_asm_acc_32_16_loop_end:

    cmp.w rptr_tmp, ctr
    vmov zetaptr, s2
    bne.w 1b

pop {r4-r11, pc}