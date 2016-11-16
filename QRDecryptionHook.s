; .text:003CD558             ; DecryptQRCode(u8 *in_ptr, int in_len, u8 *out_ptr, NetApp::QR::QRUtility *qr_utility, int qr_type)
; .text:003CD558               B        new_setup ; STMFD  SP!, {R4-R8,LR}
resume:
; .text:003CD55C               SUB      SP, SP, #0x28
; .text:003CD560               MOV      R6, R1
; [...]
; .text:003CD5E8               ADD      SP, SP, #0x28
; .text:003CD5EC               MOV      R0, R5
; .text:003CD5F0               B        new_end   ; LDMFD           SP!, {R4-R8,PC}

new_setup:
LDR R12, =dword_6A1080 ; stash parameters in static mem, could use stack but mem is unused anyway
STR R0, [R12, #0] ; static_mem[0] = in_ptr
STR R1, [R12, #4] ; static_mem[1] = in_len
STR R2, [R12, #8] ; static_mem[2] = out_ptr
STR R3, [R12, #0xC] ; static_mem[3] = this
MOV R11, #0         
STR R11, [R12, #0x10] ; static_mem[4] = 0 // have_decrypted = false
start_function:
STMFD           SP!, {R4-R8,LR}
B resume

new_end:
CMP R0, #1 ; Check if decryption succeeded
LDMFDEQ SP!, {R4-R8, PC} ; If it did, end function. Otherwise, re-decrypt with key we can sign for.
LDR R12, =dword_6A1080 ; retriever paramaters from static mem
LDR R11, [R12, #0x10] ; R11 = has_decrypted
CMP R11, #3 ; if (has_decrypted) { return; }
LDMFDEQ SP!, {R4-R8, PC}
LDMFD SP!, {R4-R8, LR} ; unclobber registers to state at start of function
LDR R0, [R12, #0] 
LDR R1, [R12, #4]
LDR R2, [R12, #8]
LDR R3, [R12, #0xC]
MOV R11, #3 ; R11 = 3
STR R11, [SP, #0] ; qr_type = 3
STR R11, [R12, #0x10] ; static_mem[4] = 3 // has_decrypted = 3
B start_function