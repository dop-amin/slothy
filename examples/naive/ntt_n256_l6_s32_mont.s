
///
/// Copyright (c) 2021 Arm Limited
/// Copyright (c) 2022 Hanno Becker
/// SPDX-License-Identifier: MIT
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///



///
/// This assembly code has been auto-generated.
/// Don't modify it directly.
///

.data
roots:
.word   29095681 // zeta^128 * 2^31 = 28678040^128 * 2^31 = 17702291 * 2^31
.word 3280343807 // zeta^128 * f(q^(-1) mod 2^32) * 2^31 = 28678040^128 * 375649793 * 2^31
.word   14476917 // zeta^ 64 * 2^31 = 28678040^ 64 * 2^31 = 3260327 * 2^31
.word 2356128651 // zeta^ 64 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 64 * 375649793 * 2^31
.word   43317805 // zeta^192 * 2^31 = 28678040^192 * 2^31 = 14579576 * 2^31
.word  933021651 // zeta^192 * f(q^(-1) mod 2^32) * 2^31 = 28678040^192 * 375649793 * 2^31
.word   18598075 // zeta^ 32 * 2^31 = 28678040^ 32 * 2^31 = 6733847 * 2^31
.word 2578416965 // zeta^ 32 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 32 * 375649793 * 2^31
.word   39999747 // zeta^ 16 * 2^31 = 28678040^ 16 * 2^31 = 20428075 * 2^31
.word 3454780669 // zeta^ 16 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 16 * 375649793 * 2^31
.word   45317587 // zeta^144 * 2^31 = 28678040^144 * 2^31 = 14626653 * 2^31
.word 3083517997 // zeta^144 * f(q^(-1) mod 2^32) * 2^31 = 28678040^144 * 375649793 * 2^31
.word    4885007 // zeta^160 * 2^31 = 28678040^160 * 2^31 = 12909577 * 2^31
.word 2973633521 // zeta^160 * f(q^(-1) mod 2^32) * 2^31 = 28678040^160 * 375649793 * 2^31
.word   48811299 // zeta^ 80 * 2^31 = 28678040^ 80 * 2^31 = 29737761 * 2^31
.word 4050555101 // zeta^ 80 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 80 * 375649793 * 2^31
.word   54571669 // zeta^208 * 2^31 = 28678040^208 * 2^31 = 30285189 * 2^31
.word 4085587819 // zeta^208 * f(q^(-1) mod 2^32) * 2^31 = 28678040^208 * 375649793 * 2^31
.word   64683161 // zeta^ 96 * 2^31 = 28678040^ 96 * 2^31 = 14745691 * 2^31
.word 3091135847 // zeta^ 96 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 96 * 375649793 * 2^31
.word   59281651 // zeta^ 48 * 2^31 = 28678040^ 48 * 2^31 = 21289485 * 2^31
.word 3509906701 // zeta^ 48 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 48 * 375649793 * 2^31
.word   40500013 // zeta^176 * 2^31 = 28678040^176 * 2^31 = 9914896 * 2^31
.word  634504915 // zeta^176 * f(q^(-1) mod 2^32) * 2^31 = 28678040^176 * 375649793 * 2^31
.word   34427601 // zeta^224 * 2^31 = 28678040^224 * 2^31 = 13512548 * 2^31
.word  864737071 // zeta^224 * f(q^(-1) mod 2^32) * 2^31 = 28678040^224 * 375649793 * 2^31
.word   25917637 // zeta^112 * 2^31 = 28678040^112 * 2^31 = 22603682 * 2^31
.word 1446525243 // zeta^112 * f(q^(-1) mod 2^32) * 2^31 = 28678040^112 * 375649793 * 2^31
.word    8356523 // zeta^240 * 2^31 = 28678040^240 * 2^31 = 16204162 * 2^31
.word 1036987221 // zeta^240 * f(q^(-1) mod 2^32) * 2^31 = 28678040^240 * 375649793 * 2^31
.word   31719253 // zeta^  8 * 2^31 = 28678040^  8 * 2^31 = 23825509 * 2^31
.word 3672199851 // zeta^  8 * f(q^(-1) mod 2^32) * 2^31 = 28678040^  8 * 375649793 * 2^31
.word    5075563 // zeta^  4 * 2^31 = 28678040^  4 * 2^31 = 9010590 * 2^31
.word  576633749 // zeta^  4 * f(q^(-1) mod 2^32) * 2^31 = 28678040^  4 * 375649793 * 2^31
.word   43115375 // zeta^132 * 2^31 = 28678040^132 * 2^31 = 20699126 * 2^31
.word 1324642961 // zeta^132 * f(q^(-1) mod 2^32) * 2^31 = 28678040^132 * 375649793 * 2^31
.word   54842419 // zeta^136 * 2^31 = 28678040^136 * 2^31 = 27028662 * 2^31
.word 1729702349 // zeta^136 * f(q^(-1) mod 2^32) * 2^31 = 28678040^136 * 375649793 * 2^31
.word   35131011 // zeta^ 68 * 2^31 = 28678040^ 68 * 2^31 = 341080 * 2^31
.word   21827453 // zeta^ 68 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 68 * 375649793 * 2^31
.word   44664611 // zeta^196 * 2^31 = 28678040^196 * 2^31 = 21220783 * 2^31
.word 3505510109 // zeta^196 * f(q^(-1) mod 2^32) * 2^31 = 28678040^196 * 375649793 * 2^31
.word    1316163 // zeta^ 72 * 2^31 = 28678040^ 72 * 2^31 = 14833295 * 2^31
.word 3096742077 // zeta^ 72 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 72 * 375649793 * 2^31
.word   65968403 // zeta^ 36 * 2^31 = 28678040^ 36 * 2^31 = 25331745 * 2^31
.word 3768591597 // zeta^ 36 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 36 * 375649793 * 2^31
.word   53949037 // zeta^164 * 2^31 = 28678040^164 * 2^31 = 5289426 * 2^31
.word  338497427 // zeta^164 * f(q^(-1) mod 2^32) * 2^31 = 28678040^164 * 375649793 * 2^31
.word   10391631 // zeta^200 * 2^31 = 28678040^200 * 2^31 = 2138810 * 2^31
.word  136873393 // zeta^200 * f(q^(-1) mod 2^32) * 2^31 = 28678040^200 * 375649793 * 2^31
.word   52363231 // zeta^100 * 2^31 = 28678040^100 * 2^31 = 5705868 * 2^31
.word  365147681 // zeta^100 * f(q^(-1) mod 2^32) * 2^31 = 28678040^100 * 375649793 * 2^31
.word   39928117 // zeta^228 * 2^31 = 28678040^228 * 2^31 = 17686665 * 2^31
.word 3279343819 // zeta^228 * f(q^(-1) mod 2^32) * 2^31 = 28678040^228 * 375649793 * 2^31
.word   54335767 // zeta^ 40 * 2^31 = 28678040^ 40 * 2^31 = 6490403 * 2^31
.word 2562837737 // zeta^ 40 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 40 * 375649793 * 2^31
.word   54457727 // zeta^ 20 * 2^31 = 28678040^ 20 * 2^31 = 9106105 * 2^31
.word 2730229889 // zeta^ 20 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 20 * 375649793 * 2^31
.word   27596809 // zeta^148 * 2^31 = 28678040^148 * 2^31 = 18817700 * 2^31
.word 1204240887 // zeta^148 * f(q^(-1) mod 2^32) * 2^31 = 28678040^148 * 375649793 * 2^31
.word   46002083 // zeta^168 * 2^31 = 28678040^168 * 2^31 = 19648405 * 2^31
.word 3404885597 // zeta^168 * f(q^(-1) mod 2^32) * 2^31 = 28678040^168 * 375649793 * 2^31
.word   14847715 // zeta^ 84 * 2^31 = 28678040^ 84 * 2^31 = 1579445 * 2^31
.word 2248560413 // zeta^ 84 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 84 * 375649793 * 2^31
.word    1129279 // zeta^212 * 2^31 = 28678040^212 * 2^31 = 7769916 * 2^31
.word  497236673 // zeta^212 * f(q^(-1) mod 2^32) * 2^31 = 28678040^212 * 375649793 * 2^31
.word   35733845 // zeta^104 * 2^31 = 28678040^104 * 2^31 = 31254932 * 2^31
.word 2000162987 // zeta^104 * f(q^(-1) mod 2^32) * 2^31 = 28678040^104 * 375649793 * 2^31
.word   54563587 // zeta^ 52 * 2^31 = 28678040^ 52 * 2^31 = 21843119 * 2^31
.word 3545336573 // zeta^ 52 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 52 * 375649793 * 2^31
.word   35404977 // zeta^180 * 2^31 = 28678040^180 * 2^31 = 11828796 * 2^31
.word  756985167 // zeta^180 * f(q^(-1) mod 2^32) * 2^31 = 28678040^180 * 375649793 * 2^31
.word   61099389 // zeta^232 * 2^31 = 28678040^232 * 2^31 = 26362414 * 2^31
.word 1687065731 // zeta^232 * f(q^(-1) mod 2^32) * 2^31 = 28678040^232 * 375649793 * 2^31
.word   52947923 // zeta^116 * 2^31 = 28678040^116 * 2^31 = 19828530 * 2^31
.word 1268929069 // zeta^116 * f(q^(-1) mod 2^32) * 2^31 = 28678040^116 * 375649793 * 2^31
.word   41822583 // zeta^244 * 2^31 = 28678040^244 * 2^31 = 33201112 * 2^31
.word 2124709001 // zeta^244 * f(q^(-1) mod 2^32) * 2^31 = 28678040^244 * 375649793 * 2^31
.word   26241327 // zeta^ 24 * 2^31 = 28678040^ 24 * 2^31 = 572895 * 2^31
.word 2184146129 // zeta^ 24 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 24 * 375649793 * 2^31
.word   12770159 // zeta^ 12 * 2^31 = 28678040^ 12 * 2^31 = 23713020 * 2^31
.word 1517517457 // zeta^ 12 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 12 * 375649793 * 2^31
.word   24980679 // zeta^140 * 2^31 = 28678040^140 * 2^31 = 19537976 * 2^31
.word 1250335033 // zeta^140 * f(q^(-1) mod 2^32) * 2^31 = 28678040^140 * 375649793 * 2^31
.word    5033605 // zeta^152 * 2^31 = 28678040^152 * 2^31 = 26691971 * 2^31
.word 3855639419 // zeta^152 * f(q^(-1) mod 2^32) * 2^31 = 28678040^152 * 375649793 * 2^31
.word   61827033 // zeta^ 76 * 2^31 = 28678040^ 76 * 2^31 = 8285889 * 2^31
.word 2677740071 // zeta^ 76 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 76 * 375649793 * 2^31
.word   11221523 // zeta^204 * 2^31 = 28678040^204 * 2^31 = 24690028 * 2^31
.word 1580041197 // zeta^204 * f(q^(-1) mod 2^32) * 2^31 = 28678040^204 * 375649793 * 2^31
.word    8316793 // zeta^ 88 * 2^31 = 28678040^ 88 * 2^31 = 9249292 * 2^31
.word  591909511 // zeta^ 88 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 88 * 375649793 * 2^31
.word   19091691 // zeta^ 44 * 2^31 = 28678040^ 44 * 2^31 = 4778209 * 2^31
.word 2453265685 // zeta^ 44 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 44 * 375649793 * 2^31
.word   32210035 // zeta^172 * 2^31 = 28678040^172 * 2^31 = 13113327 * 2^31
.word 2986672525 // zeta^172 * f(q^(-1) mod 2^32) * 2^31 = 28678040^172 * 375649793 * 2^31
.word   16634213 // zeta^216 * 2^31 = 28678040^216 * 2^31 = 29292862 * 2^31
.word 1874600091 // zeta^216 * f(q^(-1) mod 2^32) * 2^31 = 28678040^216 * 375649793 * 2^31
.word   20871313 // zeta^108 * 2^31 = 28678040^108 * 2^31 = 25384023 * 2^31
.word 3771937135 // zeta^108 * f(q^(-1) mod 2^32) * 2^31 = 28678040^108 * 375649793 * 2^31
.word   46581651 // zeta^236 * 2^31 = 28678040^236 * 2^31 = 10905370 * 2^31
.word  697890413 // zeta^236 * f(q^(-1) mod 2^32) * 2^31 = 28678040^236 * 375649793 * 2^31
.word   63329695 // zeta^ 56 * 2^31 = 28678040^ 56 * 2^31 = 8247799 * 2^31
.word 2675302497 // zeta^ 56 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 56 * 375649793 * 2^31
.word   51221435 // zeta^ 28 * 2^31 = 28678040^ 28 * 2^31 = 16167867 * 2^31
.word 3182148165 // zeta^ 28 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 28 * 375649793 * 2^31
.word   18467171 // zeta^156 * 2^31 = 28678040^156 * 2^31 = 22046437 * 2^31
.word 3558347933 // zeta^156 * f(q^(-1) mod 2^32) * 2^31 = 28678040^156 * 375649793 * 2^31
.word    9983051 // zeta^184 * 2^31 = 28678040^184 * 2^31 = 5086187 * 2^31
.word 2472974773 // zeta^184 * f(q^(-1) mod 2^32) * 2^31 = 28678040^184 * 375649793 * 2^31
.word   37083207 // zeta^ 92 * 2^31 = 28678040^ 92 * 2^31 = 656361 * 2^31
.word 2189487545 // zeta^ 92 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 92 * 375649793 * 2^31
.word   52674527 // zeta^220 * 2^31 = 28678040^220 * 2^31 = 18153794 * 2^31
.word 1161754145 // zeta^220 * f(q^(-1) mod 2^32) * 2^31 = 28678040^220 * 375649793 * 2^31
.word    7721125 // zeta^120 * 2^31 = 28678040^120 * 2^31 = 28113639 * 2^31
.word 3946619227 // zeta^120 * f(q^(-1) mod 2^32) * 2^31 = 28678040^120 * 375649793 * 2^31
.word    8896309 // zeta^ 60 * 2^31 = 28678040^ 60 * 2^31 = 3732072 * 2^31
.word  238834379 // zeta^ 60 * f(q^(-1) mod 2^32) * 2^31 = 28678040^ 60 * 375649793 * 2^31
.word    2061353 // zeta^188 * 2^31 = 28678040^188 * 2^31 = 22126384 * 2^31
.word 1415980503 // zeta^188 * f(q^(-1) mod 2^32) * 2^31 = 28678040^188 * 375649793 * 2^31
.word    9383201 // zeta^248 * 2^31 = 28678040^248 * 2^31 = 8471290 * 2^31
.word  542121183 // zeta^248 * f(q^(-1) mod 2^32) * 2^31 = 28678040^248 * 375649793 * 2^31
.word   23761465 // zeta^124 * 2^31 = 28678040^124 * 2^31 = 9445744 * 2^31
.word  604481479 // zeta^124 * f(q^(-1) mod 2^32) * 2^31 = 28678040^124 * 375649793 * 2^31
.word   24512363 // zeta^252 * 2^31 = 28678040^252 * 2^31 = 794839 * 2^31
.word 2198349461 // zeta^252 * f(q^(-1) mod 2^32) * 2^31 = 28678040^252 * 375649793 * 2^31
.text

// Montgomery multiplication via rounding
.macro mulmod dst, src, const, const_twisted
        vqrdmulh.s32   \dst,  \src, \const
        vmul.u32       \src,  \src, \const_twisted
        vqrdmlah.s32   \dst,  \src, modulus
.endm

.macro ct_butterfly a, b, root, root_twisted
        mulmod tmp, \b, \root, \root_twisted
        vsub.u32       \b,    \a, tmp
        vadd.u32       \a,    \a, tmp
.endm

.align 4
roots_addr: .word roots
.syntax unified
.type ntt_n256_u32_33556993_28678040_incomplete_manual, %function
.global ntt_n256_u32_33556993_28678040_incomplete_manual
ntt_n256_u32_33556993_28678040_incomplete_manual:

        push {r4-r11,lr}
        // Save MVE vector registers
        vpush {d8-d15}

        modulus  .req r12
        root_ptr .req r11

        .equ modulus_const, 33556993
        movw modulus, #:lower16:modulus_const
        movt modulus, #:upper16:modulus_const
        ldr  root_ptr, roots_addr

        in_low       .req r0
        in_high      .req r1

        add in_high, in_low, #(4*128)

        root0         .req r2
        root0_twisted .req r3
        root1         .req r4
        root1_twisted .req r5
        root2         .req r6
        root2_twisted .req r7

        data0 .req q0
        data1 .req q1
        data2 .req q2
        data3 .req q3

        tmp .req q4

        /* Layers 1-2 */

        ldrd root0, root0_twisted, [root_ptr], #+8
        ldrd root1, root1_twisted, [root_ptr], #+8
        ldrd root2, root2_twisted, [root_ptr], #+8

        mov lr, #16
layer12_loop:
        vldrw.u32 data0, [in_low]
        vldrw.u32 data1, [in_low, #(4*64)]
        vldrw.u32 data2, [in_high]
        vldrw.u32 data3, [in_high, #(4*64)]

        ct_butterfly data0, data2, root0, root0_twisted
        ct_butterfly data1, data3, root0, root0_twisted
        ct_butterfly data0, data1, root1, root1_twisted
        ct_butterfly data2, data3, root2, root2_twisted

        vstrw.u32 data0, [in_low], #16
        vstrw.u32 data1, [in_low, #(4*64 - 16)]
        vstrw.u32 data2, [in_high], #16
        vstrw.u32 data3, [in_high, #(4*64-16)]

        le lr, layer12_loop
        .unreq in_high
        .unreq in_low

        in .req r0
        sub in, in, #(64*4)

        /* Layers 3,4 */

        // 4 butterfly blocks per root config, 4 root configs
        // loop over root configs

        count .req r1
        mov count, #4

out_start:
        ldrd root0, root0_twisted, [root_ptr], #+8
        ldrd root1, root1_twisted, [root_ptr], #+8
        ldrd root2, root2_twisted, [root_ptr], #+8

        mov lr, #4
layer34_loop:

        vldrw.u32 data0, [in]
        vldrw.u32 data1, [in, #(4*1*16)]
        vldrw.u32 data2, [in, #(4*2*16)]
        vldrw.u32 data3, [in, #(4*3*16)]

        ct_butterfly data0, data2, root0, root0_twisted
        ct_butterfly data1, data3, root0, root0_twisted
        ct_butterfly data0, data1, root1, root1_twisted
        ct_butterfly data2, data3, root2, root2_twisted

        vstrw.u32 data0, [in], #16
        vstrw.u32 data1, [in, #(4*1*16 - 16)]
        vstrw.u32 data2, [in, #(4*2*16 - 16)]
        vstrw.u32 data3, [in, #(4*3*16 - 16)]
        le lr, layer34_loop

        add in, in, #(4*64 - 4*16)
        subs count, count, #1
        bne out_start

        sub in, in, #(4*256)

        /* Layers 5,6 */

        // 1 butterfly blocks per root config, 16 root configs
        // loop over root configs

        mov lr, #16
layer56_loop:
        ldrd root0, root0_twisted, [root_ptr], #+24
        ldrd root1, root1_twisted, [root_ptr, #(-16)]
        ldrd root2, root2_twisted, [root_ptr, #(-8)]

        vldrw.u32 data0, [in]
        vldrw.u32 data1, [in, #(4*1*4)]
        vldrw.u32 data2, [in, #(4*2*4)]
        vldrw.u32 data3, [in, #(4*3*4)]

        ct_butterfly data0, data2, root0, root0_twisted
        ct_butterfly data1, data3, root0, root0_twisted
        ct_butterfly data0, data1, root1, root1_twisted
        ct_butterfly data2, data3, root2, root2_twisted

        vstrw.u32 data0, [in], #64
        vstrw.u32 data1, [in, #(4*1*4 - 64)]
        vstrw.u32 data2, [in, #(4*2*4 - 64)]
        vstrw.u32 data3, [in, #(4*3*4 - 64)]

        le lr, layer56_loop

        // Restore MVE vector registers
        vpop {d8-d15}
        // Restore GPRs
        pop {r4-r11,lr}
        bx lr
