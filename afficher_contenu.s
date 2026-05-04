#include "image_bits_include.h"

        .global afficher_contenu
        .text

afficher_contenu:
    push {r4, lr}          @ sauvegarder registres

    mov r1, #0             @ i = 0
    ldr r2, =BYTES
    ldr r2, [r2]           @ r2 = taille totale

loop_aff:
    cmp r1, r2
    bge fin_aff

    add r3, r0, r1         @ adresse courant
    ldrb r4, [r3]          @ charger octet

    mov r0, r4             @ préparer paramètre
    bl afficher_octet      @ appel fonction C pour afficher octet

    add r1, r1, #1
    b loop_aff

fin_aff:
    pop {r4, lr}
    bx lr