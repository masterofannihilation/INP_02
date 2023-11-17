
; DATA SEGMENT
.data
login:          .asciiz "xhatal02"
params_sys5:    .space  8   ; Space for storing the address of the string for syscall 5

; CODE SEGMENT
.text
main:
    daddi r4, $zero, login  ; Načítanie adresy zoraďovaného reťazca

outer_loop:
    xor $t6, $t6, $t6          ;swap flag vypnuty

inner_loop:
    lb $t2, 0(r4)       ; Načítanie znaku z reťazca
    lb $t3, 1(r4)       ; Načítanie znaku z reťazca + 1

    beqz $t3, end_sort    ;ak sme na konci, tak ideme dopici
    
    dsub $t5, $t2, $t3           ;porovnanie znakov vacsi mensi
    daddi $t5, $t5, -1          ;
    bgez $t5, swap              ;ak je t2 vacsi ako t3 tak swap
    daddi r4, r4, 1              ;posun na dalsi znak
    j inner_loop;               ;skok na zaciatok

    swap:
        sb $t2, 1(r4)               ;swap
        sb $t3, 0(r4)               ;swap
        xori $t6, $zero, 1           ;nastavenie swap flagu
        daddi r4, r4, 1              ;posun na dalsi znak
        j inner_loop

end_sort:
    daddi r4, $zero, login      ;nastavenie adresy na zaciatok
    bnez $t6, outer_loop ;ak bol swap tak opakujeme, ak ne , print
    jal print_string    ; vypis pomoci print_string - viz nize
    syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
    syscall 5   ; systemova procedura - vypis retezce na terminal
    jr      r31 ; return - r31 je urcen na return address