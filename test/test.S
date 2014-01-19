#add lr, pc, #8
#ldw r0, =0x556c
#add pc, r21, r0
mov r1, #5
mov r0, #0

ldw r2, [r18+], r1<<#2
stw r2, [r18+], r0<<#2

ldh.w r20, [r17+], #2
and r28, r20, #255
add pc, r21, r28<<#6
