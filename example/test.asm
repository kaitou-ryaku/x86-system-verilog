bits 32

; ----- mov -----

mov eax, 0x12345678  ; mem[4:1] = 12345678
mov ecx, 0x12345432  ; mem[9:6] = 12345432
mov edx, 0x1
mov ebx, 0x6

mov esi, [edx]  ; esi=12345678 mod=00
mov esi, [edx+5]; esi=12345432 mod=01
mov esi, [ebx-5]; esi=12345678 mod=01

mov [edx  ], ecx    ; mem[4:1]=12345432 mod=00
mov [edx+5], eax    ; mem[9:6]=12345678 mod=01
mov [ebx-5], eax    ; mem[4:1]=12345678 mod=01
mov esi, edx        ; esi=1             mod=11

; ----- ope [M+imm], R -----

add [edx], ebx      ; mem[4:1]=mem[4:1]+ebx ; mem[4:1] = 1234567E
add [edx+5], edx    ; mem[9:6]=mem[9:6]+edx ; mem[9:6] = 12345679
add [ebx-5], edx    ; mem[4:1]=mem[4:1]+edx ; mem[4:1] = 1234567F
add esi, edx        ; esi=esi+edx ; esi=2

sub [edx], ebx      ; mem[4:1]=mem[4:1]-ebx ; mem[4:1] = 12345679
sub [edx+5], edx    ; mem[9:6]=mem[9:6]-edx ; mem[9:6] = 12345678
sub [ebx-5], edx    ; mem[4:1]=mem[4:1]-edx ; mem[4:1] = 12345678
sub esi, edx        ; esi=esi-edx ; esi=1

; esi=1, edi=0

mov esi, 0x2        ; esi=2
mov edi, 0x1        ; edi=1
cmp esi, edi        ; cf=0 zf=0 sf=0 of=0

mov edi, 0x2        ; edi=2
cmp esi, edi        ; cf=0 zf=1 sf=0 of=0

mov edi, 0x3        ; edi=3
cmp esi, edi        ; cf=1 zf=0 sf=1 of=0

mov esi, -0x7fffffff; esi=-0x7fffffff = b100..001 = 0x80000001
cmp esi, edi        ; cf=0 zf=0 sf=0 of=1

; ----- push -----

push eax            ; mem[MEMSIZE- 1:MEMSIZE- 4]=12345678  , esp=MEMSIZE-4
push ecx            ; mem[MEMSIZE- 5:MEMSIZE- 8]=12345432  , esp=MEMSIZE-8
push edx            ; mem[MEMSIZE- 9:MEMSIZE-12]=1         , esp=MEMSIZE-12
push ebx            ; mem[MEMSIZE-13:MEMSIZE-16]=6         , esp=MEMSIZE-16
push esp            ; mem[MEMSIZE-17:MEMSIZE-20]=MEMSIZE-16, esp=MEMSIZE-20
push ebp            ; mem[MEMSIZE-21:MEMSIZE-24]=0         , esp=MEMSIZE-24
push esi            ; mem[MEMSIZE-25:MEMSIZE-28]=0x80000001, esp=MEMSIZE-28
push edi            ; mem[MEMSIZE-29:MEMSIZE-32]=3         , esp=MEMSIZE-32

; ----- pop -----

pop eax             ; eax=3,         esp=MEMSIZE-28
pop ecx             ; ecx=0x80000001,esp=MEMSIZE-24
pop edx             ; edx=0,         esp=MEMSIZE-20
pop ebx             ; ebx=16,        esp=MEMSIZE-16

pop ebp             ; ebp=6,         esp=MEMSIZE-12
pop esi             ; esi=1,         esp=MEMSIZE-8
pop edi             ; edi=12345432,  esp=MEMSIZE-4

mov edi, esp        ; edi=MEMSIZE-4
pop esp             ; esp=12345678
mov esp, edi        ; esp=MEMSIZE-4

; ----- calc -----

mov eax, 0x0        ; eax=0
add eax, 0x2        ; eax=eax+0x2,  eax=2;
sub eax, 0x2        ; eax=eax-0x2,  eax=0;

; ----- cmp -----

mov esi, 0x2        ; esi=2
cmp esi, 0x1        ; cf=0 zf=0 sf=0 of=0
cmp esi, 0x2        ; cf=0 zf=1 sf=0 of=0
cmp esi, 0x3        ; cf=1 zf=0 sf=1 of=0

mov esi, -0x7fffffff; esi=-0x7fffffff = b100..001 = 0x80000001
cmp esi, 0x3        ; cf=0 zf=0 sf=0 of=1

; ----- jmp -----
jmp _1_             ; eb 05
mov eax, 0x12345678
_1_:
jmp _2_             ; e9 82 00 00 00
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
mov eax, 0x12345678
_2_:
;eax == 0
mov eax, 0x87654321

mov esi, 0x2;
mov edi, 0x2;
cmp esi, edi;
je _3_
mov eax, 0x1
_3_:

mov esi, 0x2;
mov edi, 0x3;
cmp esi, edi;
je _4_
mov eax, 0x2
_4_:

mov esi, 0x3;
mov edi, 0x2;
cmp esi, edi;
je _5_
mov eax, 0x3
_5_:

mov esi, 0x2;
mov edi, 0x2;
cmp esi, edi;
jg _6_
mov eax, 0x4
_6_:

mov esi, 0x2;
mov edi, 0x3;
cmp esi, edi;
jg _7_
mov eax, 0x5
_7_:

mov esi, 0x3;
mov edi, 0x2;
cmp esi, edi;
jg _8_
mov eax, 0x6
_8_:

mov esi, 0x2;
mov edi, 0x2;
cmp esi, edi;
jl _9_
mov eax, 0x7
_9_:

mov esi, 0x2;
mov edi, 0x3;
cmp esi, edi;
jl _10_
mov eax, 0x8
_10_:

mov esi, 0x3;
mov edi, 0x2;
cmp esi, edi;
jl _11_
mov eax, 0x9
_11_:

hlt
