.model small

cseg segment para public 'code'
  assume ss:cseg,cs:cseg,ds:cseg
  org 100h

START:
   jmp short milena
   M db 'M'

milena proc near
   
   mov ah,02h
   mov dl,M
   int 21h

   mov ah,4Ch
   mov al,147
   int 21h

   call knt
   ret

milena endp

knt proc near
 
   mov ah,02h
   mov dl,13
   int 21h

   mov ah,4Ch
   mov dl,10
   int 21h

knt endp
cseg ends
end START                             
                                               