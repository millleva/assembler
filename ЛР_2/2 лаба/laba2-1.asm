.model small

sseg segment para stack 'stack'
  db 256 dup(?)
sseg ends

dseg segment para public 'data'
  M db 'M'
dseg ends

cseg segment para public 'code'
  assume cs:cseg,ss:sseg,es:nothing

start proc far
 
  assume ds:dseg
  mov bx,dseg
  mov ds,bx

  mov ah,02h
  mov dl,M
  int 21h

  mov ah,4Ch
  mov al,147
  int 21h

start endp
cseg ends
end start

                                                                         