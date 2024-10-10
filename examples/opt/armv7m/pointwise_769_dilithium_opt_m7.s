/**
 * Copyright (c) 2023 Junhao Huang (jhhuang_nuaa@126.com)
 *
 * Licensed under the Apache License, Version 2.0(the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
.syntax unified
.cpu cortex-m4
.thumb

###################################
#### small point-multiplication####
#### r0: out; r1: in; r2: zetas####
###################################
.align 2
.global small_pointmul_asm_769_opt_m7
.type small_pointmul_asm_769_opt_m7, %function
small_pointmul_asm_769_opt_m7:
    push.w {r4-r11, lr}

    movw r14, #24608 // qa
    movt r12, #769  // q
    .equ width, 4


    add.w r3, r2, #64*width
    _point_mul_16_loop:
        _point_mul_16_loop_start:
                                         // Instructions:    24
                                         // Expected cycles: 16
                                         // Expected IPC:    1.50
                                         //
                                         // Wall time:     0.15s
                                         // User time:     0.15s
                                         //
                                         // ----- cycle (expected) ------>
                                         // 0                        25
                                         // |------------------------|----
        ldr.w r7, [r1, #2*width]         // *.............................
        ldr.w r11, [r1, #3*width]        // *.............................
        ldr.w r4, [r1, #1*width]         // .*............................
        ldr.w r10, [r2, #1*width]        // .*............................
        ldr.w r6, [r1], #4*width         // ..*...........................
        ldr.w r5, [r2], #2*width         // ..*...........................
        smulwt r8, r10, r7               // ...*..........................
        smulwt r9, r5, r6                // ....*.........................
        neg.w r5, r5                     // ....*.........................
        smulwt r5, r5, r4                // .....*........................
        neg.w r10, r10                   // .....*........................
        smulwt r10, r10, r11             // ......*.......................
        smlabt r5, r5, r12, r14          // .......*......................
        smlabt r9, r9, r12, r14          // ........*.....................
        pkhbt r5, r4, r5                 // .........*....................
        str.w r5, [r0, #1*width]         // .........*....................
        smlabt r10, r10, r12, r14        // ..........*...................
        pkhbt r5, r6, r9                 // ..........*...................
        smlabt r4, r8, r12, r14          // ...........*..................
        str.w r5, [r0], #2*width         // ...........*..................
        pkhbt r5, r11, r10               // ............*.................
        str.w r5, [r0, #1*width]         // .............*................
        pkhbt r5, r7, r4                 // ..............*...............
        str.w r5, [r0], #2*width         // ...............*..............

                                          // ------ cycle (expected) ------>
                                          // 0                        25
                                          // |------------------------|-----
        // ldr.w r7, [r1, #2*width]       // *..............................
        // ldr.w r8, [r1, #3*width]       // *..............................
        // ldr.w r9, [r2, #1*width]       // .*.............................
        // ldr.w r5, [r1, #1*width]       // .*.............................
        // ldr.w r4, [r1], #4*width       // ..*............................
        // ldr.w r6, [r2], #2*width       // ..*............................
        // smulwt r10, r6, r4             // ....*..........................
        // smlabt r10, r10, r12, r14      // ........*......................
        // pkhbt r4, r4, r10              // ..........*....................
        // neg.w r6, r6                   // ....*..........................
        // smulwt r10, r6, r5             // .....*.........................
        // smlabt r10, r10, r12, r14      // .......*.......................
        // pkhbt r5, r5, r10              // .........*.....................
        // str.w r5, [r0, #1*width]       // .........*.....................
        // str.w r4, [r0], #2*width       // ...........*...................
        // smulwt r10, r9, r7             // ...*...........................
        // smlabt r10, r10, r12, r14      // ...........*...................
        // pkhbt r7, r7, r10              // ..............*................
        // neg.w r9, r9                   // .....*.........................
        // smulwt r10, r9, r8             // ......*........................
        // smlabt r10, r10, r12, r14      // ..........*....................
        // pkhbt r8, r8, r10              // ............*..................
        // str.w r8, [r0, #1*width]       // .............*.................
        // str.w r7, [r0], #2*width       // ...............*...............

        _point_mul_16_loop_end:


    cmp.w r2, r3
    bne.w _point_mul_16_loop

    pop.w {r4-r11, pc}