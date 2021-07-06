# Programa do exemplo1

        MOV R0, #0xCDEF
        MOVT R0, #0x89AB
        MOV R1, #0x4567
        MOVT R1, #0x0123
> Coloca em R0 0x89ab cdef \
> Coloca em R1 0x0123 4567 \
> R1R0 -> 0x0123 4567 89ab cdef


        MOV R2, #0x4321
        MOVT R2, #0x8765
        MOV R3, #0xCBA9
        MOVT R3, #0X0FED

> Coloca em R2 0x8765 4321 \
> Coloca em R3 0x0FED CBA9 \
> R3R2 -> 0x0fed cba9 8765 4321

        // COMO LIMPA CARRY BIT?? - esta operação não leva em conta o estado atual, e prepara o carry bit para a operação seguinte.
        ADDS R0, R0, R2

> resulta em R0 0x1111 1110 \
com C = 1

        ADC R1, R1, R3

> resulta em R1 0x1111 1111 \
indicando que o valor de 64 bits é \
R1R0 = 0x1111 1111 1111 1110

Fazendo a soma manualmente temos:\
                        
 R1R0 -> 0x0123 4567 89ab cdef\
 R3R2 -> 0x0fed cba9 8765 4321\
 R1R0 =  0x1111 1111 1111 1110                  


## trocando a instrução ADDS por ADD
        ADD R0, R0, R2

> resulta em R0 0x1111 1110 \
com C = 0 -> não é alterado!

        ADC R1, R1, R3

> resulta em R1 0x1111 1110 \
indicando que o valor de 64 bits é \
R1R0 = 0x1111 1110 1111 1110 -> que é o valor errado para a soma.

## Voltando à condição enicial e trocando ADC por ADD

        ADDS R0, R0, R2

> resulta em R0 0x1111 1110 \
com C = 1

        ADD R1, R1, R3

> resulta em R1 0x1111 1110 \
Esta instrução não utilizou o Carry, mesmo estando setado.
O valor obtido de 64 bits é \
R1R0 = 0x1111 1110 1111 1110 -> que é o valor errado para a soma.

## Invertendo as instruçoes
        ADC R0, R0, R2

> resulta em R0 0x1111 1110 \
com C = 0 - não alterado.

        ADDS R1, R1, R3

> resulta em R1 0x1111 1110 \
Esta instrução não utilizou o Carry.
O valor obtido de 64 bits é \
R1R0 = 0x1111 1110 1111 1110 -> que é o valor errado para a soma.

## Conclusões:
O sufixo S é necesário para que haja sinalização dos flags do resultado da operação no registrador APSR. A instrução que soma o bit mais significativo precisa fazer o uso do bit C.

Apenas a sequência
       ADDS R0, R0, R2
       ADC R1, R1, R3

resulta na soma correta de 64 bits.

Se o flag C estiver setado em 1 imediatamente antes da primeira operação ele não será considerado por causa da instrução ADDS, que atualiza o estado do APSR para C=1, como resultado de sua operação. A operação seguinte utiliza este bit. Caso haja algum desvio de execução, o APSR deve ser armazenado juntamente com o PC.

