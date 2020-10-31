format PE console

include 'win32a.inc'

entry start
;-----------------------------------------------
; �������: ����������� ����� ���������         |
; ������: ���194                               |
; �������: 13                                  |
; ������� ������:                              |
; ����������� ��������� ����������� ���������� |
; ����� ����� �� 1 �� ������������ ��������    |
; ��������� �����                              |
;-----------------------------------------------
section '.data' data readable writable

        strPrintNum      db '%u', 0
        strCountFermaNum db 'Count of Ferma numbers: %d', 10, 0

        maxDword         dd 4294967295 ;������������� �������� dword


        NULL = 0


section '.code' code readable executable

;____________________MAIN___________________
        start:
                push [maxDword]         ;���������� � ���� �������� dword
                call findCountFermaNum  ;�������� findCountFermaNum
                add  esp, 4             ;������� ���������� ���������

                push eax                ;���������� � ���� findCountFermaNum(maxDword)
                push strCountFermaNum   ;���������� � ���� ������
                call [printf]           ;������� ��������� ���������� ����� �����
                add  esp, 8             ;������� ���������� ���������

                call [getch]            ;��������� ���� �������

                push NULL               ;���������� � ���� ��� ������
                call ExitProcess        ;��������� ������ ���������

;____________________MAIN___________________



; ��������:
; �������� ����� number � ������� power
;
; ���������:
; num - �����, ���������� � �����-�� �������
; power - ������� � ������� ����� ���������� number
;
; ����������
; number ����������� � ������� power
;
;_____________________POW___________________
        pow:
                ;������ �������
                push ecx
                push ebp
                mov  ebp, esp
                sub  esp, 4             ;�������� ����� ��� ���. ����������

;----------���������-����������------------
        i       equ  ebp-4              ;�������
;---------------���������------------------
        num     equ  ebp+16             ;���������� � ������� �����
        power   equ  ebp+12             ;�������
;------------------------------------------

                mov  eax, 1             ;result=1
                mov  [i], dword 0       ;i=0
        powLoop:
                mov  ecx, [i]           ;ecx = i ��� ���������
                cmp  ecx, [power]       ;���������� i �� power
                jge  finishPowLoop      ;� ������ ���� i >= power ������� �� �����

                imul eax, dword [num]   ;�������� ��������� �� �����

                inc  dword [i]          ;i++
                jmp  powLoop            ;����������� � ������ �����

        finishPowLoop:
                ;������ �������
                mov  esp, ebp
                pop  ebp
                pop  ecx

        ret
;_____________________POW___________________



; ��������:
; ������� ��� ����� ����� ������ maxValue � ������� �� � �������.
; � �������� ���������� ������������ ���������� ��������� ����� �����
;
; ���������:
; maxValue - ������������ ����� � ������� ����� ������������ ����� �����
;
; ����������:
; ���������� ��������� ����� ����� ������� ������������� ��������
; unsigned dword
;
;___________FIND_COUNT_OF_FERMA_NUM_________

        findCountFermaNum:
                ;������ �������
                push ecx
                push ebp
                mov  ebp, esp
                sub  esp, 8            ;�������� ����� ��� ���. ����������

;----------���������-����������------------
        i       equ  ebp-4              ;�������
        oldVal  equ  ebp-8              ;���������� ��������
        val     equ  ebp-12             ;�������� ��������
;---------------���������------------------
        maxVal  equ  ebp+12             ;����������� ���������� ��������
;------------------------------------------

                mov [i], dword 0        ;i = 0
                mov [oldVal], dword 0   ;oldValue = 0

        fermaLoop:
                push dword [i]          ;���������� � ���� i
                call findFermaNum       ;�������� findFermaNum
                add  esp, 4             ;������� ���������� ���������

                mov [val], eax          ;val = findFermaNum(i)
                mov ecx, [val]          ;ecx = val
                cmp ecx, [oldVal]       ;���������� val �� oldVal (�������� ������������)
                jb finishFermaLoop      ;���� ������ oldVal, �� ������� �� �����

                mov [oldVal], ecx       ;oldVal = val
                inc dword [i]           ;ecx++

                jmp fermaLoop           ;� ������ �����

        finishFermaLoop:
                mov eax, [i]            ;���������� ��������� � eax
                ;������ �������
                mov esp, ebp
                pop ebp
                pop ecx

        ret
;___________FIND_COUNT_OF_FERMA_NUM_________


; ��������:
; ������� ����� ����� ��� ������� n
;
; ���������:
; n - ����� �������� ����� �����
;
; ����������:
; ����� ����� ��� ������� n
;
;_______________FIND_FERMA_NUM______________

        findFermaNum:
                ;������ �������
                push ebp
                mov  ebp, esp

;----------------���������-----------------
        n       equ  ebp+8              ;����� �������� ����� �����
;------------------------------------------

                ;������� 2^n
                push 2                  ;���������� � ���� 2
                push dword [n]          ;���������� � ���� n
                call pow                ;�������� pow
                add  esp, 8             ;������� ���������� ���������
                ;������� 2^(2^n)
                push 2                  ;���������� � ���� 2
                push eax                ;���������� � ���� pow(n)
                call pow                ;�������� pow
                add  esp, 8             ;������� ���������� ���������

                ;������ �������
                mov esp, ebp
                pop ebp

        ret

;_______________FIND_FERMA_NUM_____________

section '.idata' data readable import

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'