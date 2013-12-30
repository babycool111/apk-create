ldw r0, =0x30006110                                                                                                                                                                             
ldw r1, [r0]
and r1, r1, #0xFFFFFDFF
stw r1, [r0]

ldw r0, =0x30006114
ldw r1, [r0]
or r1, r1,  #0x00000200                                                                     
stw r1, [r0]

ldw r0, =0x30006118
ldw r1, [r0]
and r1, r1, #0xFFFFFDFF
stw r1, [r0]

