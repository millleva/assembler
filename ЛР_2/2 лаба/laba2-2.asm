cseg segment para public 'code'
  assume ss:cseg,ds:cseg,ss:cseg
START:
  M db 'M'
  
  mov ah,02h
  mov dl,M
  int 21h

  mov dl,13
  int 21h

  mov dl,10
  int 21h

  mov ah,4Ch
  mov al,147
  int 21h

cseg ends
end START

                                              
                                                                                                      