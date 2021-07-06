        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
main    
 // valor 1 -> 0x0123 4567 89AB CDEF -> R1R0
 // Valor 2 -> 0x0FED CBA9 8765 4321 -> R3R2

        MOV R0, #0xCDEF
        MOVT R0, #0x89AB
        MOV R1, #0x4567
        MOVT R1, #0x0123
        
        MOV R2, #0x4321
        MOVT R2, #0x8765
        MOV R3, #0xCBA9
        MOVT R3, #0X0FED
        
        // COMO LIMPA CARRY BIT??
     ;   ADDS R0, R0, R2
     ;   ADC R1, R1, R3
        
     ;   ADD R0, R0, R2
     ;   ADC R1, R1, R3
        
     ;   ADDS R0, R0, R2
     ;   ADD R1, R1, R3

        ADC R0, R0, R2
        ADDS R1, R1, R3


        B       main

        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
