; .text:003CD8A4 NetApp::QR::QRUtility::AnalyzeQRBinaryForApp(gfl2::heap::CtrHeapBase *, void const*, unsigned int, pml::pokepara::CoreParam *, bool &)
; .text:003CD8A4                 STMFD  SP!, {R0-R11,LR}
; .text:003CD8A8                 SUB    SP, SP, #0x7C
; .text:003CD8AC                 B      hook  ; MOV R8, R0
; resume:
; .text:003CD8B0                 MOV             R10, R1
; [...]
; cleanup:
; .text:003CDD30                 BLNE   operator delete[](void *)  
; .text:003CDD34                 ADD    SP, SP, #0x8C
; .text:003CDD38                 MOV    R0, R4
; .text:003CDD3C                 LDMFD  SP!, {R4-R11,PC}

hook:
MOV     R8, R0
LDR     R6, =_0x1A2 ; data variable, loaded through PC-relative address
CMP     R2, R6
BNE     resume ; Size validated.
MOV     R10, R1 ; Store Reg1 = data_ptr
MOV     R11, R2 ; Store Reg2 = size
SUB     R2, R2, #0x2 ; crc_size = qr_size - 2
MOV     R9, R3
MOV     R0, #0 ; R0 = 0
BL      gfl2::math::Crc::Crc16(ushort,uchar const*,int ; R0 = CRC16(data, lol)
ADD     R1, R10, #0x1A0
LDRH    R1, [R1] ; R1 = stored_crc
CMP     R0, R1
MOV     R1, R10
MOV     R2, R11
BNE     resume ; Short-circuit if stored_crc != actual_crc
ADD     R0, R10, #0x30
LDR     R1, [R10, #0x8]
LDR     R2, [R10, #0xC]
LDR     R3, [R10, #0x10]
BL      InjectPokemonToBox ; InjectPokemonToBox(pkm, box, slot, copies)
LDR     R0, [R8] ; Pokemon is injected, prepare dex QR data to fake an alolan scan
LDR     R1, [R0,#0x34]
MOV     R0, R8
BLX     R1
MOV     R1, R0
MOV     R0, #0x60
BL      operator new[](uint,gfl2::heap::CtrHeapBase *) ; Allocate new dex data in ctrheap, necessary for VSTR/VLDR to not data abort
MOV     R11, R0
ADD     R1, R10, #0x140 ; R0 = dex_qr_data
MOV     R2, #0x60
STMFD   SP!, {R4-R12} ; save registers
BL      _aeabi_memcpy ; memcpy(dex_data_in_heap, dex_data_in_qr, 0x60)
LDMFD   SP!, {R4-R12} ; Unclobber registers
MOV     R0, R11
LDR     R7, [SP, #0xB0] ; R7 = display_gender_addr
LDRB    R1, [R0, #0x2D] ; R1 = is_gendered
STRB    R1, [R7] ; *display_gender_addr = is_gendered -- required for correct display
MOV     R2, R8 ; R2 = NetApp:QR::QRUtility*
LDR     R1, [SP, #0x88] ; R1 = Pokeparam for display
BL      generate_dex_display_data ; generate_dex_display_data(dex_data_in_heap, pokeparam_for_display, qr_utility)
MOV     R4, R0
MOV     R0, R11
B       cleanup   ; cleanup = 0x3CDD30, normal end of function