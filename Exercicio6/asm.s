        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
main    
       MOV R8, #143
       MOV R9, #3

//preparando registradores para multiplicação:
       MOV R0, R8
       MOV R1, R9
       BL Mul8b  ; Executa produto
       MOV R10, R2  ; Produto em R10
       
//preparando registradores para divisão:
       MOV R0, R8
       MOV R1, R9
       BL Div8b
       MOV R11, R2
       MOV R12, R3       
       
        B       main


// subrotina de multiplicação
// valores de entrada em R0 e R1
// produto em R2
Mul8b
        MOV R2,#0;

MLoop:   CBZ R0, MFim
        ADD R2, R2, R1
        SUB R0, R0, #1
        B MLoop

MFim:    BX LR ; retorno

// divisão de 8 bits
// entrada em R0 e R1
// saida em R2 (quociente) e R3 (resto)
Div8b
        MOV R2,#0;
        MOV R3,#0;
DLoop:   SUBS R0, R0, R1 ; subtrai R1 de R0, guarda em R0
        BMI DSaida ; pula se resultado negativo
        ADD R2, R2, #1 ; ADICIONA 1 AO QUOCIENTE
        B DLoop
DSaida:  ADD R3, R0, R1 ; CALCULA O RESTO
        BX LR ;  retorna 




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
