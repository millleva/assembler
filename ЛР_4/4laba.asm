.model small

sseg segment para stack 'stack' ; объ€вление стека
  db 256 dup(?)
sseg ends

dseg segment para public 'data' ; объ€влеине сегмента данных
  crlf db 0Dh,0Ah,'$'
  prnt db ' Input value','$'
  mesA db ' A:', '$'
  mesB db ' B:', '$'
  resM db 8 dup(' '), 'Result: ', '$'
  errF db ' Format Input Erorr', '$'
  buff db 32
  blen db ?
  binp db 32 dup (' '),'$'
  bout db 32 dup (' '),'$'
dseg ends

cseg segment para public 'code'
  assume cs:cseg,ss:sseg,es:nothing
begin proc far
  assume ds:dseg
  mov bx,dseg
  mov ds,bx

  lea dx,crlf ; показатель на переменную crlf (далее везде тоже показатели на разные переменные)
  call output ; вызов функции output

  lea dx,prnt
  call output

  lea dx,mesA
  call output

  lea dx,buff
  call input

  lea dx,crlf
  call output

  call to10num ; вызов функции to10num
  push ax

  lea dx,prnt
  call output

  lea dx,mesB
  call output

  lea dx,buff
  call input

  lea dx,crlf
  call output

  call to10num
  push ax

  pop bx   ; B y BX
  pop ax   ; A y AX

;
  add ax,bx   ; додаванн€ A + B (ax+bx)
;
  push ax  ; ax y stack

  lea dx,crlf  ; получаем показатель на переменную crlf
  call output  ; вызов функции output

  lea dx,resM  ; получаем показатель на переменную resM
  call output

  pop ax

  call to10str

  lea dx,bout
  add dx,di
  call output

  lea dx,crlf
  call output

  mov ah,4Ch
  mov al,00h   ; exit ot OS
  int 21h
begin endp

output proc near
  xor ax,ax
  mov ah,09h
  int 21h
  ret
output endp

input proc near
  xor ax,ax
  mov ah,0Ah
  int 21h
  ret
input endp

;перевод символа в дес€тичное число
to10num proc near
  xor ax,ax    ; AX = 0
  xor bx,bx    ; BX = 0
  xor cx,cx    ; CX = 0
  xor di,di    ; DI = 0 - номер сайта в буфере
  mov cl,blen  ; CL = длинна р€дка
  mov si,cx    ; SI = последн€€ позици€ в строке
  mov cx,10    ; CX = 10, система вычеслени€
asc2bin:
  mov bl,byte ptr binp[di]   ; переназначени€ типа байту
  sub bl,'0'                 ; число = код символу ASCII - 30h ('0')
  jb asc_err                 ; если (код символа ( код '0'),
  cmp bl,9                   ; если (число > 9), то
  ja asc_err                 ; вызывает выход программы в проводник
  mul cx                     ; иначе - умножить поточный результат на 10
  add ax,bx                  ; добавить к поточному результату новый разр€д числа
  inc di                     ; перейти к след байту в буфере 
  cmp di,si                  ; если считано SI, последний символ в р€дке, то выход
  jb asc2bin
  ret
asc_err:
  call errFormat
to10num endp

to10str proc near
  xor dx,dx
  mov dl,buff
  dec dl
  mov di,dx
  mov cx,10
m1:
  cmp ax,cx
  jb m2
  xor dx,dx
  div cx
  add dx,'0'
  mov bout[di],dl
  dec di
  jmp m1
m2:
  add ax,'0'
  mov bout[di],al
  ret
to10str endp

errFormat proc near
  lea dx,errF
  call output
  mov ah,4Ch
  mov al,01h
  int 21h
errFormat endp

cseg ends

end begin