; Injects num_copies copies of a pk7 to a player's boxes, beginning at box "box", and ending at slot "slot".
int InjectPokemonToBox(u8 *pk7, int box, int slot, int num_copies)
    STMFD   SP!, {R4-R11,LR}
    SUB     SP, SP, #0xC
    STR     R0, [SP, #0x4]
    BL      gfl2::base::SingletonAccessor<GameSys::GameManager>::GetInstance
    MOV     R12, R0
    LDR     R12, [R12, #0x24]
    LDR     R12, [R12, #0x4]
    ADD     R12, R12, #0x3C00
    ADD     R12, R12, #0x310
    MOV     R6, #0x1E
    MOV     R7, #0x3C0
    MUL     R1, R1, R6
    ADD     R1, R1, R2
    SUB     R7, R7, R1 ; R7 = max_times
    CMP     R3, R7
    MOVGT   R3, R7
    STR     R3, [SP, #0x8]
    MOV     R6, #0xE8
    MUL     R1, R1, R6
    ADD     R12, R12, R1
    STR     R12, [SP, #0x0] ; data_base
    memcpy_loop:
    LDR     R0, [SP, #0x0]
    LDR     R1, [SP, #0x4]
    MOV     R2, #0xE8
    BL      _aeabi_memcpy
    LDR     R3, [SP, #0x8]
    CMP     R3, #0x1
    BGT     continue
    MOV     R0, #0x0
    ADD     SP, SP, #0xC
    LDMFD   SP!, {R4-R11, PC}
    continue:
    SUB     R3, R3, #0x1
    STR     R3, [SP, #0x8]
    LDR     R0, [SP, #0x0]
    ADD     R0, #0xE8
    STR     R0, [SP, #0x0]
    B       memcpy_loop