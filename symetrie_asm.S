 #include "image_bits_include.h"

        .global symetrie_octet
        .global permuter_cols
        .global symetrie_axe_v
        .global permuter_lignes
        .global symetrie_axe_h

        .text

@ ================================
@ symetrie_octet
@ ================================
#ifndef C_SYMETRIE_OCTET

symetrie_octet:
    push {lr}

    ldrb r1, [r0]

    @ --- swap 4 bits ---
    and r2, r1, #0xF0
    lsr r2, r2, #4
    and r3, r1, #0x0F
    lsl r3, r3, #4
    orr r1, r2, r3

    @ --- swap 2 bits ---
    and r2, r1, #0xCC
    lsr r2, r2, #2
    and r3, r1, #0x33
    lsl r3, r3, #2
    orr r1, r2, r3

    @ --- swap 1 bit ---
    and r2, r1, #0xAA
    lsr r2, r2, #1
    and r3, r1, #0x55
    lsl r3, r3, #1
    orr r1, r2, r3

    strb r1, [r0]

    pop {pc}

#endif


@ ================================
@ permuter_cols
@ ================================
#ifndef C_PERMUTER_COLS

permuter_cols:
    push {r4, r5, lr}

    ldr r2, =BYTES_PER_LINE
    ldr r2, [r2]

    sub r3, r2, #1
    sub r3, r3, r1

    ldrb r4, [r0, r3]
    ldrb r5, [r0, r1]

    strb r5, [r0, r3]
    strb r4, [r0, r1]

    pop {r4, r5, pc}

#endif


@ ================================
@ symetrie_axe_v
@ ================================
#ifndef C_SYMETRIE_AXE_V

symetrie_axe_v:
    push {r4-r8, lr}

    mov r4, r0              @ sauvegarde base image

    @ --- boucle symetrie_octet ---
    mov r1, #0
    ldr r2, =BYTES
    ldr r2, [r2]

loop_octet:
    cmp r1, r2
    bge fin_octet

    add r0, r4, r1
    bl symetrie_octet

    add r1, r1, #1
    b loop_octet

fin_octet:

    @ --- boucle lignes ---
    mov r5, #0              @ li
    ldr r6, =HEIGHT
    ldr r6, [r6]

loop_li:
    cmp r5, r6
    bge fin_v

    ldr r7, =BYTES_PER_LINE
    ldr r7, [r7]

    mul r8, r5, r7
    add r8, r4, r8          @ adresse ligne

    mov r1, #0
    mov r3, r7
    lsr r3, r3, #1          @ BPL / 2

loop_col:
    cmp r1, r3
    bge next_li

    mov r0, r8
    bl permuter_cols

    add r1, r1, #1
    b loop_col

next_li:
    add r5, r5, #1
    b loop_li

fin_v:
    pop {r4-r8, pc}

#endif

@ ================================
@ permuter_lignes
@ ================================
#ifndef C_PERMUTER_LIGNES
permuter_lignes:
    push {r4, r5, lr}
    ldr r2, =HEIGHT
    ldr r2, [r2]
    sub r3, r2, #1
    sub r3, r3, r1
    ldrb r4, [r0, r1]
    ldrb r5, [r0, r3]
    strb r5, [r0, r1]
    strb r4, [r0, r3]
    pop {r4, r5, pc}
#endif

@ ================================
@ symetrie_axe_h
@ ================================
#ifndef C_SYMETRIE_AXE_H

symetrie_axe_h:
    push {r4-r7, lr}
    mov r4, r0              @ base image
    mov r5, #0              @ li
    ldr r6, =HEIGHT
    ldr r6, [r6]
    lsr r6, r6, #1          @ HEIGHT/2
loop_li_h:
    cmp r5, r6
    bge fin_h
    mov r7, #0              @ col
    ldr r3, =BYTES_PER_LINE
    ldr r3, [r3]
loop_col_h:
    cmp r7, r3
    bge next_li_h
    add r0, r4, r7
    mov r1, r5
    bl permuter_lignes
    add r7, r7, #1
    b loop_col_h
next_li_h:
    add r5, r5, #1
 b loop_li_h
fin_h:
    pop {r4-r7, pc}
#endif 
