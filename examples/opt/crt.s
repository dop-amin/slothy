vqdmulh.s32 q3, q0, mod_p                  // ...........*..................................
vand.u32 q5, q4, qmask                     // ..............*...............................
vmul.u32 q0, q3, const_shift9              // .............*................................
vldrw.u32 q3, [src0]                       // .......................*......................
vqdmulh.s32 q1, q3, mod_p_tw               // ........................*.....................
vshr.u32 q6, q4, #22                       // ............*.................................
vqrdmulh.s32 q1, q1, const_prshift         // .........................*....................
vorr.u32 q0, q6, q0                        // ...............*..............................
vmla.s32 q3, q1, mod_p                     // ..........................*...................
vshlc q0, rcarry, #32                      // ................*.............................
vldrw.u32 q4, [src1]                       // ...........................*..................
vsub.u32 q4, q4, q3                        // ............................*.................
vqdmulh.s32 q1, q4, p_inv_mod_q_tw         // .............................*................
vadd.u32 q6, q2, q0                        // .................*............................
vmul.u32 q4, q4, p_inv_mod_q               // ..............................*...............
vrshr.s32 q0, q1, #(SHIFT)                 // ...............................*..............
vldrw.u32 q2, [src0]                       // e.............................................
vmla.s32 q4, q0, mod_q_neg                 // ................................*.............
vadd.u32 q0, q5, q6                        // ..................*...........................
vmul.u32 q6, q4, mod_p                     // .................................*............
vand.u32 q1, q0, qmask                     // ...................*..........................
vqdmulh.s32 q5, q4, mod_p                  // ..................................*...........
vshlc q0, rcarry_red, #32                  // ....................*.........................
vqdmlah.s32 q1, q0, const_rshift22         // .....................*........................
vshr.u32 q4, q6, #22                       // ...................................*..........
vmul.u32 q5, q5, const_shift9              // ....................................*.........
vand.u32 q6, q6, qmask                     // .....................................*........
vqdmulh.s32 q0, q2, mod_p_tw               // .e............................................
vorr.u32 q5, q4, q5                        // ......................................*.......
vqrdmulh.s32 q0, q0, const_prshift         // ..e...........................................
vshlc q5, rcarry, #32                      // .......................................*......
vmla.s32 q2, q0, mod_p                     // ...e..........................................
vadd.u32 q3, q3, q5                        // ........................................*.....
vldrw.u32 q4, [src1]                       // ....e.........................................
vsub.u32 q0, q4, q2                        // .....e........................................
vqdmulh.s32 q4, q0, p_inv_mod_q_tw         // ......e.......................................
vadd.u32 q5, q6, q3                        // .........................................*....
vmul.u32 q0, q0, p_inv_mod_q               // .......e......................................
vrshr.s32 q3, q4, #(SHIFT)                 // ........e.....................................
vstrw.u32 q1, [dst]                        // ......................*.......................
vmla.s32 q0, q3, mod_q_neg                 // .........e....................................
vand.u32 q6, q5, qmask                     // ..........................................*...
vmul.u32 q4, q0, mod_p                     // ..........e...................................
vshlc q5, rcarry_red, #32                  // ...........................................*..
vqdmlah.s32 q6, q5, const_rshift22         // ............................................*.
vstrw.u32 q6, [dst]                        // .............................................*

// original source code
// vldrw.u32 in0, [src0]                          // e...........................................................................
// vqdmulh.s32 diff, in0, mod_p_tw                // ...........e................................................................
// vqrdmulh.s32 tmp, diff, const_prshift          // .............e..............................................................
// vmla.s32 in0, tmp, mod_p                       // ...............e............................................................
// vldrw.u32 in1, [src1]                          // .................e..........................................................
// vsub.u32 diff, in1, in0                        // ..................e.........................................................
// vqdmulh.s32 tmp, diff, p_inv_mod_q_tw          // ...................e........................................................
// vmul.u32 diff, diff, p_inv_mod_q               // .....................e......................................................
// vrshr.s32 tmp, tmp, #(SHIFT)                   // ......................e.....................................................
// vmla.s32 diff, tmp, mod_q_neg                  // ........................e...................................................
// vmul.u32 quot_low, diff, mod_p                 // ..........................e.................................................
// vqdmulh.s32 tmp, diff, mod_p                   // ..............................*.............................................
// vshr.u32 tmpp, quot_low, #22                   // ...................................*........................................
// vmul.u32 tmp, tmp, const_shift9                // ................................*...........................................
// vand.u32 quot_low, quot_low, qmask             // ...............................*............................................
// vorr.u32 tmpp, tmpp, tmp                       // .....................................*......................................
// vshlc tmpp, rcarry, #32                        // .......................................*....................................
// vadd.u32 in0, in0, tmpp                        // ...........................................*................................
// vadd.u32 tmpp, quot_low, in0                   // ................................................*...........................
// vand.u32 red_tmp, tmpp, qmask                  // ..................................................*.........................
// vshlc tmpp, rcarry_red, #32                    // ....................................................*.......................
// vqdmlah.s32 red_tmp, tmpp, const_rshift22      // .....................................................*......................
// vstrw.u32 red_tmp, [dst]                       // .....................................................................*......
// vldrw.u32 in0, [src0]                          // .................................*..........................................
// vqdmulh.s32 diff, in0, mod_p_tw                // ..................................*.........................................
// vqrdmulh.s32 tmp, diff, const_prshift          // ....................................*.......................................
// vmla.s32 in0, tmp, mod_p                       // ......................................*.....................................
// vldrw.u32 in1, [src1]                          // ........................................*...................................
// vsub.u32 diff, in1, in0                        // .........................................*..................................
// vqdmulh.s32 tmp, diff, p_inv_mod_q_tw          // ..........................................*.................................
// vmul.u32 diff, diff, p_inv_mod_q               // ............................................*...............................
// vrshr.s32 tmp, tmp, #(SHIFT)                   // .............................................*..............................
// vmla.s32 diff, tmp, mod_q_neg                  // ...............................................*............................
// vmul.u32 quot_low, diff, mod_p                 // .................................................*..........................
// vqdmulh.s32 tmp, diff, mod_p                   // ...................................................*........................
// vshr.u32 tmpp, quot_low, #22                   // ......................................................*.....................
// vmul.u32 tmp, tmp, const_shift9                // .......................................................*....................
// vand.u32 quot_low, quot_low, qmask             // ........................................................*...................
// vorr.u32 tmpp, tmpp, tmp                       // ..........................................................*.................
// vshlc tmpp, rcarry, #32                        // ............................................................*...............
// vadd.u32 in0, in0, tmpp                        // ..............................................................*.............
// vadd.u32 tmpp, quot_low, in0                   // ..................................................................*.........
// vand.u32 red_tmp, tmpp, qmask                  // .......................................................................*....
// vshlc tmpp, rcarry_red, #32                    // .........................................................................*..
// vqdmlah.s32 red_tmp, tmpp, const_rshift22      // ..........................................................................*.
// vstrw.u32 red_tmp, [dst]                       // ...........................................................................*
