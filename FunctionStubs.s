; Stubs nn:cfg::CTR::IsDebugMode to always return false in order to create space for another patch.

; .text:00104DE0             ; nn::cfg::CTR::IsDebugMode(void)
; .text:00104DE0               MOV      R0, #0 ; LDR             R0, =0x1FF80000
; .text:00104DE4               BX       LR     ; LDRB            R0, [R0,#0x14]

; Stubs Savedata::QRReaderSaveData::BatteryQuery to always return 100, also creates space for another patch.

; .text:0043DA80             ; Savedata::QRReaderSaveData::BatteryQuery
; .text:0043DA80               MOV      R6, #0x64      ; STMFD    SP!, {R4-R7,LR}
; .text:0043DA84               STRB     R6, [R0, #0xA] ; SUB      SP, SP, #0x14
; .text:0043DA88               BX       LR             ; MOV      R4, R0

; Stubs Savedata::QRReaderSaveData::IsRegisteredData to always return false, also creates space for another patch.

; .text:004A7008             ; Savedata::QRReaderSaveData::IsRegisteredData(gfl2::heap::CtrHeapBase *, void const*, unsigned int)
; .text:004A7008               MOV      R0, #0 ; STMFD           SP!, {R4-R10,LR}
; .text:004A700C               BX       LR     ; SUB             SP, SP, #0x20

; Enables the scanning of pokedex QRs containing legendaries -- overwrites the ban list (0x311-0x322) with zeroes.

; .data.r:005A3FF0             DCD 0
; .data.r:005A3FF4             DCD 0
; .data.r:005A3FF8             DCD 0
; .data.r:005A3FFC             DCD 0
; .data.r:005A4000             DCD 0
; .data.r:005A4004             DCD 0
; .data.r:005A4008             DCD 0
; .data.r:005A400C             DCD 0
; .data.r:005A4010             DCD 0