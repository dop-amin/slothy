        vldrw.s32 q3, [inB]               // *........
        nop                               // .......*.
        vldrw.s32 q0, [inD]               // .*.......
        nop                               // ........*
        vldrw.s32 q7, [inC]               // ....*....
        vhadd.s32 q1, q3, q0              // .....*...
        vldrw.s32 q6, [inA]               // ...*.....
        vhadd.s32 q2, q6, q7              // ......*..
        vldrw.s32 q5, [pW2] , #16         // ..*......
        
        // original source code
        // vldrw.s32 q3, [inB]            // *........
        // vldrw.s32 q0, [inD]            // ..*......
        // vldrw.s32 q5, [pW2] , #16      // ........*
        // vldrw.s32 q6, [inA]            // ......*..
        // vldrw.s32 q7, [inC]            // ....*....
        // vhadd.s32 q1, q3, q0           // .....*...
        // vhadd.s32 q2, q6, q7           // .......*.
        // nop                            // .*.......
        // nop                            // ...*.....
        
        sub lr, lr, #1
        wls lr, lr, loop_end
loop_start:
        vhadd.s32 q4, q2, q1                // ........*................
        vstrw.u32 q4, [inA] , #16           // .........*...............
        vhsub.s32 q1, q2, q1                // ..........*..............
        vqdmladhx.s32 q4, q5, q1            // ............*............
        vhsub.s32 q0, q3, q0                // .......*.................
        vldrw.s32 q3, [inB, #16]            // ..e......................
        vhsub.s32 q2, q6, q7                // .....*...................
        vldrw.s32 q7, [pW1] , #16           // ................*........
        vqdmlsdh.s32 q4, q5, q1             // .............*...........
        vldrw.s32 q6, [pW3] , #16           // .....................*...
        vhcadd.s32 q5, q2, q0, #90          // ....................*....
        vstrw.u32 q4, [inB] , #16           // ..............*..........
        vhcadd.s32 q1, q2, q0, #270         // ...............*.........
        vqdmladhx.s32 q4, q6, q5            // ......................*..
        vldrw.s32 q0, [inD, #16]            // ...e.....................
        vqdmlsdh.s32 q4, q6, q5             // .......................*.
        vldrw.s32 q5, [pW2] , #16           // ...........e.............
        vqdmladhx.s32 q2, q7, q1            // .................*.......
        vldrw.s32 q6, [inA]                 // e........................
        vqdmlsdh.s32 q2, q7, q1             // ..................*......
        vldrw.s32 q7, [inC, #16]            // .e.......................
        vhadd.s32 q1, q3, q0                // ......e..................
        vstrw.u32 q2, [inC] , #16           // ...................*.....
        vhadd.s32 q2, q6, q7                // ....e....................
        vstrw.u32 q4, [inD] , #16           // ........................*
        
        // original source code
        // vldrw.s32 vecA, [inA]                             // .............e...............................
        // vldrw.s32 vecC, [inC]                             // ...............e.............................
        // vldrw.s32 vecB, [inB]                             // e............................................
        // vldrw.s32 vecD, [inD]                             // .........e...................................
        // vhadd.s32 vecSum0, vecA, vecC                     // ..................e..........................
        // vhsub.s32 vecDiff0, vecA, vecC                    // ..........................*..................
        // vhadd.s32 vecSum1, vecB, vecD                     // ................e............................
        // vhsub.s32 vecDiff1, vecB, vecD                    // ........................*....................
        // vhadd.s32 vecTmp0, vecSum0, vecSum1               // ....................*........................
        // vstrw.u32 vecTmp0, [inA] , #16                    // .....................*.......................
        // vhsub.s32 vecTmp0, vecSum0, vecSum1               // ......................*......................
        // vldrw.s32 vecW, [pW2] , #16                       // ...........e.................................
        // vqdmladhx.s32 vecTmp1, vecW, vecTmp0              // .......................*.....................
        // vqdmlsdh.s32 vecTmp1, vecW, vecTmp0               // ............................*................
        // vstrw.u32 vecTmp1, [inB] , #16                    // ...............................*.............
        // vhcadd.s32 vecTmp0, vecDiff0, vecDiff1, #270      // ................................*............
        // vldrw.s32 vecW, [pW1] , #16                       // ...........................*.................
        // vqdmladhx.s32 vecTmp1, vecW, vecTmp0              // .....................................*.......
        // vqdmlsdh.s32 vecTmp1, vecW, vecTmp0               // .......................................*.....
        // vstrw.u32 vecTmp1, [inC] , #16                    // ..........................................*..
        // vhcadd.s32 vecTmp0, vecDiff0, vecDiff1, #90       // ..............................*..............
        // vldrw.s32 vecW, [pW3] , #16                       // .............................*...............
        // vqdmladhx.s32 vecTmp1, vecW, vecTmp0              // .................................*...........
        // vqdmlsdh.s32 vecTmp1, vecW, vecTmp0               // ...................................*.........
        // vstrw.u32 vecTmp1, [inD] , #16                    // ............................................*
        
        le lr, loop_start
loop_end:
        vhadd.s32 q4, q2, q1                // *.................
        vstrw.u32 q4, [inA] , #16           // .*................
        vhsub.s32 q1, q2, q1                // ..*...............
        vqdmladhx.s32 q4, q5, q1            // ...*..............
        vhsub.s32 q0, q3, q0                // ....*.............
        vqdmlsdh.s32 q4, q5, q1             // .......*..........
        vhsub.s32 q2, q6, q7                // .....*............
        vldrw.s32 q6, [pW3] , #16           // ........*.........
        vhcadd.s32 q5, q2, q0, #90          // .........*........
        vstrw.u32 q4, [inB] , #16           // ..........*.......
        vqdmladhx.s32 q4, q6, q5            // ............*.....
        vhcadd.s32 q1, q2, q0, #270         // ...........*......
        vqdmlsdh.s32 q4, q6, q5             // .............*....
        vldrw.s32 q7, [pW1] , #16           // ......*...........
        vqdmladhx.s32 q2, q7, q1            // ..............*...
        vstrw.u32 q4, [inD] , #16           // .................*
        vqdmlsdh.s32 q2, q7, q1             // ...............*..
        vstrw.u32 q2, [inC] , #16           // ................*.
        
        // original source code
        // vhadd.s32 q4, q2, q1             // *.................
        // vstrw.u32 q4, [inA] , #16        // .*................
        // vhsub.s32 q1, q2, q1             // ..*...............
        // vqdmladhx.s32 q4, q5, q1         // ...*..............
        // vhsub.s32 q0, q3, q0             // ....*.............
        // vhsub.s32 q2, q6, q7             // ......*...........
        // vldrw.s32 q7, [pW1] , #16        // .............*....
        // vqdmlsdh.s32 q4, q5, q1          // .....*............
        // vldrw.s32 q6, [pW3] , #16        // .......*..........
        // vhcadd.s32 q5, q2, q0, #90       // ........*.........
        // vstrw.u32 q4, [inB] , #16        // .........*........
        // vhcadd.s32 q1, q2, q0, #270      // ...........*......
        // vqdmladhx.s32 q4, q6, q5         // ..........*.......
        // vqdmlsdh.s32 q4, q6, q5          // ............*.....
        // vqdmladhx.s32 q2, q7, q1         // ..............*...
        // vqdmlsdh.s32 q2, q7, q1          // ................*.
        // vstrw.u32 q2, [inC] , #16        // .................*
        // vstrw.u32 q4, [inD] , #16        // ...............*..
        
