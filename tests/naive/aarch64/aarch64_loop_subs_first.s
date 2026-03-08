count .req w2

start:
    subs count, count, #2
    add x5, x5, x4
    add x7, x5, x1
    ldr x5, [x0, #4]
    add x5, x5, x7
    b.gt start

start2:
    add x5, x5, x4
    add x7, x5, x1
    subs count, count, #2
    ldr x5, [x0, #4]
    add x5, x5, x7
    bgt start2

start3:
    subs count, count, #2
    add x5, x5, x4
    add x7, x5, x1
    ldr x5, [x0, #4]
    add x5, x5, x7
    b.cs start3

start4:
    subs count, count, #0x30
    add x5, x5, x4
    add x7, x5, x1
    ldr x5, [x0, #4]
    add x5, x5, x7
    b.hs start4

start5:
    add x5, x5, x4
    add x7, x5, x1
    subs count, count, #2
    ldr x5, [x0, #4]
    add x5, x5, x7
    b.ne start5

start6:
    add x5, x5, x4
    add x7, x5, x1
    ldr x5, [x0, #4]
    subs count, count, #2
    add x5, x5, x7
    bne start6
