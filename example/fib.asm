bits 32
org 0x0
jmp _main_

_main_:
push ebp
mov ebp, esp
sub esp, 0x10
mov eax, 0xa
push eax
call _fib_
pop edx
push eax
mov [ebp-0x4], eax
mov eax, [ebp-0x4]; a
push eax
pop eax
jmp _program_halt_

_fib_:
push ebp
mov ebp, esp
sub esp, 0x10
mov eax, [ebp+0x8]; n
push eax
mov eax, 0x2
push eax
pop edx
pop eax
cmp eax, edx
jg  LABEL_while_begin_true_39
mov eax, 0x0
jmp LABEL_while_begin_end_39
LABEL_while_begin_true_39:
mov eax, 0x1
LABEL_while_begin_end_39:
push eax
pop eax
cmp eax, 0
je  LABEL36_else
mov eax, [ebp+0x8]; n
push eax
mov eax, 0x2
push eax
pop edx
pop eax
sub  eax, edx
push eax
call _fib_
pop edx
push eax
mov eax, [ebp+0x8]; n
push eax
mov eax, 0x1
push eax
pop edx
pop eax
sub  eax, edx
push eax
call _fib_
pop edx
push eax
pop edx
pop eax
add  eax, edx
push eax
mov [ebp-0x4], eax
jmp LABEL36_if_end
LABEL36_else:
mov eax, [ebp+0x8]; n
push eax
mov eax, 0x2
push eax
pop edx
pop eax
cmp eax, edx
je  LABEL_while_begin_true_65
mov eax, 0x0
jmp LABEL_while_begin_end_65
LABEL_while_begin_true_65:
mov eax, 0x1
LABEL_while_begin_end_65:
push eax
pop eax
cmp eax, 0
je  LABEL62_else
mov eax, 0x1
push eax
mov [ebp-0x4], eax
jmp LABEL62_if_end
LABEL62_else:
mov eax, [ebp+0x8]; n
push eax
mov eax, 0x1
push eax
pop edx
pop eax
cmp eax, edx
je  LABEL_while_begin_true_79
mov eax, 0x0
jmp LABEL_while_begin_end_79
LABEL_while_begin_true_79:
mov eax, 0x1
LABEL_while_begin_end_79:
push eax
pop eax
cmp eax, 0
je  LABEL76_if_end
mov eax, 0x1
push eax
mov [ebp-0x4], eax
LABEL76_if_end:
LABEL62_if_end:
LABEL36_if_end:
mov eax, [ebp-0x4]; ret
push eax
pop eax
leave
ret

_program_halt_:
hlt
