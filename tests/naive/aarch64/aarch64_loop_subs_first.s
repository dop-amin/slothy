count .req w2

start:
    subs count, count, #2
    add x5, x5, x4
    add x7, x5, x1
    add x5, x5, x7
    b.gt start

start2:
    add x5, x5, x4
    subs count, count, #2
    add x7, x5, x1
    add x5, x5, x7
    b.ne start2
