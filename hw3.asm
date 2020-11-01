format PE console

include 'win32a.inc'

entry start
;-----------------------------------------------
; Студент: Назмутдинов Роман Ренатович         |
; Группа: БПИ194                               |
; Вариант: 13                                  |
; Условие задачи:                              |
; Разработать программу определения количества |
; чисел Ферма от 1 до беззнакового двойного    |
; машинного слова                              |
;-----------------------------------------------
section '.data' data readable writable

        strPrintNum      db '%u', 0
        strCountFermaNum db 'Count of Ferma numbers: %d', 10, 0

        maxDword         dd 4294967295 ;Максимаольное значение dword


        NULL = 0


section '.code' code readable executable

;____________________MAIN___________________
        start:
                push [maxDword]         ;Записываем в стек максимум dword
                call findCountFermaNum  ;Вызываем findCountFermaNum
                add  esp, 4             ;Удаляем переданные агрументы

                push eax                ;Записываем в стек findCountFermaNum(maxDword)
                push strCountFermaNum   ;Записываем в стек шаблон
                call [printf]           ;Выводим найденное количество чисел Ферма
                add  esp, 8             ;Удаляем переданные аргументы

                call [getch]            ;Считываем ввод символа

                stdcall [ExitProcess], 0;Завершаем работу программы

;____________________MAIN___________________

; Описание:
; Возводит число number в степень power
;
; Аргументы:
; num - число, возводимое в какую-то степень
; power - степень в которую будет возведенно number
;
; Возвращает
; number возведенное в степень power
;
;_____________________POW___________________
        pow:
                ;Пролог функции
                push ecx
                push ebp
                mov  ebp, esp
                sub  esp, 4             ;Выделяем место для лок. переменных

;----------Локальные-переменные------------
        i       equ  ebp-4              ;Счетчик
;---------------Параметры------------------
        num     equ  ebp+16             ;Возводимое в степень число
        power   equ  ebp+12             ;Степень
;------------------------------------------

                mov  eax, 1             ;result=1
                mov  [i], dword 0       ;i=0
        powLoop:
                mov  ecx, [i]           ;ecx = i для сравнения
                cmp  ecx, [power]       ;Сравниваем i со power
                jge  finishPowLoop      ;В случае если i >= power выходим из цикла

                imul eax, dword [num]   ;Умножаем результат на число

                inc  dword [i]          ;i++
                jmp  powLoop            ;Возврщаемся в начало цикла

        finishPowLoop:
                ;Эпилог функции
                mov  esp, ebp
                pop  ebp
                pop  ecx

        ret
;_____________________POW___________________

; Описание:
; Находит все числа Ферма меньше maxValue и выводит их в консоль.
; в качестве результата возвращается количество найденных числе Ферма
;
; Аргументы:
; maxValue - максимальное число с которым будут сравниваться числа Ферма
;
; Возвращает:
; Количество найденных чисел Ферма меньших максимальному значению
; unsigned dword
;
;___________FIND_COUNT_OF_FERMA_NUM_________

        findCountFermaNum:
                ;Пролог функции
                push ecx
                push ebp
                mov  ebp, esp
                sub  esp, 8            ;Выделяем место для лок. переменных

;----------Локальные-переменные------------
        i       equ  ebp-4              ;Счетчик
        oldVal  equ  ebp-8              ;Предыдущее значение
        val     equ  ebp-12             ;Нынешнее значение
;---------------Параметры------------------
        maxVal  equ  ebp+12             ;Максимально допустимое значение
;------------------------------------------

                mov [i], dword 0        ;i = 0
                mov [oldVal], dword 0   ;oldValue = 0

        fermaLoop:
                push dword [i]          ;Записываем в стек i
                call findFermaNum       ;Вызываем findFermaNum
                add  esp, 4             ;Удаляем переданные аргументы

                mov [val], eax          ;val = findFermaNum(i)
                mov ecx, [val]          ;ecx = val
                cmp ecx, [oldVal]       ;Сравниваем val со oldVal (проверка переполнения)
                jb finishFermaLoop      ;Если меньше oldVal, то выходим из цикла

                mov [oldVal], ecx       ;oldVal = val
                inc dword [i]           ;ecx++

                jmp fermaLoop           ;В начало цикла

        finishFermaLoop:
                mov eax, [i]            ;Записываем результат в eax
                ;Эпилог функции
                mov esp, ebp
                pop ebp
                pop ecx

        ret
;___________FIND_COUNT_OF_FERMA_NUM_________


; Описание:
; Находит число Ферма под номером n
;
; Аргументы:
; n - номер искомого числа Ферма
;
; Возвращает:
; Число Ферма под номером n
;
;_______________FIND_FERMA_NUM______________

        findFermaNum:
                ;Пролог функции
                push ebp
                mov  ebp, esp

;----------------Параметры-----------------
        n       equ  ebp+8              ;Номер искомого числа Ферма
;------------------------------------------

                ;Находим 2^n
                push 2                  ;Записываем в стек 2
                push dword [n]          ;Записываем в стек n
                call pow                ;Вызываем pow
                add  esp, 8             ;Удаляем переданные аргументы
                ;Находим 2^(2^n)
                push 2                  ;Записываем в стек 2
                push eax                ;Записываем в стек pow(n)
                call pow                ;Вызываем pow
                add  esp, 8             ;Удаляем переданные аргументы
                inc  eax                ;прибавляем к результату 1

                ;Эпилог функции
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
