section .data
inputInstruc: db "请输入开头数字和结尾数字，以空格隔开：",0Ah  
inputLength: equ $-inputInstruc
msg: db "OK",0Ah
msglen: equ $-msg
num: dw 0
start: dw 0
end: dw 0
return: db 0Ah
color_red: db 1Bh,'[31;1m',0
color_red_len: equ $-color_red
color_green: db 1Bh,'[32;1m',0
color_green_len: equ $-color_green
color_yellow: db 1Bh,'[33;1m',0
color_yellow_len: equ $-color_yellow
color_blue: db 1Bh,'[34;1m',0
color_blue_len: equ $-color_blue
para1_1: dq 0 ;用于计算fib
para1_2: dq 0
para1_3: dq 1
para2_1: dq 0
para2_2: dq 0
para2_3: dq 1 
para0_1: dq 0
para0_2: dq 0
para0_3: dq 0

section .bss
inputBuf: resb 1   ;用于读取输入的数字
out: resb 1
index: resb 1

section .text
global _start
_start:  ;读取输入
mov eax,4
mov ebx,1
mov ecx,inputInstruc
mov edx,inputLength
int 80h

input:
mov eax,3
mov ebx,0
mov ecx,inputBuf
mov edx,1
int 80h

cmp byte[inputBuf],10
je setEnd

cmp byte[inputBuf],32
je setStart

sub byte[inputBuf],'0'
mov ax,word[num]
mov bl,10
mul bl
movzx bx,byte[inputBuf]
add ax,bx
mov word[num],ax
jmp input

setEnd:
mov ax,word[num]
mov word[end],ax
mov word[num],0
jmp fibFunc

setStart:
mov ax,word[num]
mov word[start],ax
mov word[num],0
jmp input

fibFunc:

mov ax,word[start]
mov word[num],ax
cmp word[num],0
je setZero
cmp word[num],1
je setOne
cmp word[num],2
je setOne

mov qword[para1_1],0
mov qword[para1_2],0
mov qword[para1_3],1
mov qword[para2_1],0
mov qword[para2_2],0
mov qword[para2_3],1

fibLoop:
mov rax,qword[para1_3]
add rax,qword[para2_3]
mov qword[para0_3],rax

mov rax,qword[para1_2]
adc rax,qword[para2_2]
mov qword[para0_2],rax

mov rax,qword[para1_1]
adc rax,qword[para2_1]
mov qword[para0_1],rax 

cmp word[num],3
je outPut
sub word[num],1
mov rax,qword[para1_3]
mov qword[para2_3],rax
mov rax,qword[para0_3]
mov qword[para1_3],rax
mov rax,qword[para1_2]
mov qword[para2_2],rax
mov rax,qword[para0_2]
mov qword[para1_2],rax
mov rax,qword[para1_1]
mov qword[para2_1],rax
mov rax,qword[para0_1]
mov qword[para1_1],rax
jmp fibLoop

setZero:
mov qword[para0_1],0
mov qword[para0_2],0
mov qword[para0_3],0
mov word[num],0
jmp outPut

setOne:
mov qword[para0_1],0
mov qword[para0_2],0
mov qword[para0_3],1
mov word[num],0
jmp outPut

outPut:
mov byte[index],0

push:
xor rdx,rdx

mov rax,qword[para0_1]
mov rbx,10
div rbx
mov qword[para0_1],rax

mov rax,qword[para0_2]
mov rbx,10
div rbx
mov qword[para0_2],rax

mov rax,qword[para0_3]
mov rbx,10
div rbx
mov qword[para0_3],rax

push rdx
add byte[index],1
cmp qword[para0_1],0
jne push
cmp qword[para0_2],0
jne push
cmp qword[para0_3],0
je print
jmp push

print:
pop rdx
mov byte[out],dl
add byte[out],'0'

mov ax,word[start]
mov bx,4
xor dx,dx
div bx
cmp dx,0
je printRed
cmp dx,1
je printGreen
cmp dx,2
je printYellow
call printBlue

write:
mov eax,4
mov ebx,1
mov ecx,out
mov edx,1
int 80h

sub byte[index],1
cmp byte[index],0
jne print

mov eax,4
mov ebx,1
mov ecx,return
mov edx,1
int 80h

mov ax,word[end]
add word[start],1
cmp word[start],ax
ja exit

mov word[num],0
jmp fibFunc

exit:
mov eax,1
mov ebx,0
int 80h

printBlue:
mov eax,4
mov ebx,1
mov ecx,color_blue
mov edx,color_blue_len
int 80h
ret

printGreen:
mov eax,4
mov ebx,1
mov ecx,color_green
mov edx,color_green_len
int 80h
jmp write

printRed:
mov eax,4
mov ebx,1
mov ecx,color_red
mov edx,color_red_len
int 80h
jmp write

printYellow:
mov eax,4
mov ebx,1
mov ecx,color_yellow
mov edx,color_yellow_len
int 80h
jmp write
