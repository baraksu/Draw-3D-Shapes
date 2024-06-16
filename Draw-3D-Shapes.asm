
.MODEL small
.STACK 256

.DATA
logo db  " _____ ______   _ ____"   ,13,10  
logo1 db " |_  _|__  / | | |  _ \",13,10 
logo2 db "  | |   / /| | | | |_) | ",13,10
logo3 db "  | |  / /_| |_| |  _ <   ",13,10
logo4 db "  |_| /____|\___/|_| \_\    ",13,10, "$"

mode db 13h
x_center dw ? 
num dw ?
y_center dw ?
x1 dw ?
y1 dw ?
w dw ?
h dw ?
numy dw ?
numx dw ?
result dw ? 
divider_num1 dw ?
divider_num2 dw ?  
divider_result dw ?
ratio_num1 dw ?
ratio_num2 dw ?  
ratio_result dw ?
color db ? 
diagonal_x1 dw ?
diagonal_y1 dw ?
diagonal_x2 dw ?     
diagonal_y2 dw ? 
current_ratio dw ? 
current_x_drew dw ? 
current_y_drew dw ?
current_x_ratio dw ?
current_y_ratio dw ? 
userwidth dw ?
curx dw ?
cury dw ? 
new_curx dw ?
new_cury dw ? 
mousebutton dw ?
msg1 db 13,10,,'  1: cube 2: pyramid' ,13,10,'$'
msg2 db 13,10,,'  please enter cube dimesion 1-99 press enter when done' ,13,10,'$' 
  
     


.CODE
square1 proc
    mov cx, [x1]
    add cx, [w]
    mov dx, [y1]
 mov [color], 4
    mov al, [color]
u1:
    mov ah, 0ch
    int 10h
    dec cx
    cmp cx, [x1]
    ja u1
    mov cx, [x1]
    add cx, [w]
    mov dx, [y1]
    add dx, [h]
    mov [color], 4
    mov al, [color]
u2:
    mov ah, 0ch
    int 10h
    dec cx
    cmp cx, [x1]
    ja u2
    mov cx, [x1]
    mov dx, [y1]
    add dx, [h]
    mov [color], 4
    mov al, [color]
u3:
    mov ah, 0ch
    int 10h
    dec dx
    cmp dx, [y1]
    ja u3
    mov cx, [x1]
    add cx, [w]
    mov dx, [y1]
    add dx, [h]
    mov [color], 4
    mov al, [color]
u4:
    mov ah, 0ch
    int 10h
    dec dx
    cmp dx, [y1]
    ja u4
    ret
square1 endp
divider proc
    MOV ax, [divider_num1]     ;Load numerator in BH  
    xor dx, dx
    MOV bx, [divider_num2]     ;Load denominator in AL
    DIV bx            ;Divide BH by AL
    mov [divider_result], ax
   
    ret  
divider endp    

ratio  proc
           
    mov ax, [ratio_num2]
    sub ax, [ratio_num1]
    MOV [ratio_result], ax
    ret
ratio endp  
 
draw_diagonal proc
    printx:  
    dec [diagonal_x1]  
    mov ax, [current_ratio]
    mov [current_y_drew], ax
    mov cx, [diagonal_x1]
    mov dx, [diagonal_y1]
    mov [color], 4
    mov al, [color]   
    mov ah, 0ch
    int 10h
             
    mov ax, [diagonal_x2]              
    cmp [diagonal_x1], ax
    je  stop_draw

    cmp current_ratio, 0
    jne printy
    
    printy:
    inc [diagonal_y1]
    dec [current_y_drew]
    cmp [current_y_drew],0
    je printx
    mov cx, [diagonal_x1]
    mov dx, [diagonal_y1]
    mov [color], 4
    mov al, [color]   
    mov ah, 0ch
    int 10h
    cmp ax, ax
    je printy
    stop_draw:
    ret
    
    
    
    
draw_diagonal endp 


; according to the ratio print points in y for each x points
draw_diagonal_left_to_right proc
    mov ax, [current_x_ratio]
    mov [current_x_drew], ax
  printx1:  
    inc [diagonal_x1] 
    mov cx, [diagonal_x1]
    mov dx, [diagonal_y1]
    mov [color], 4
    mov al, [color]   
    mov ah, 0ch
    int 10h
               
    ; in case we printed all required x points fniish drawing the diagonal
    mov ax, [diagonal_x1]              
    cmp [diagonal_x2], ax
    je  stop_draw1
        
    ; loop till x ratio is 0
    dec [current_x_drew]
    cmp [current_x_drew],0 
    jne printx1
         
    mov ax, [current_y_ratio]
    mov [current_y_drew], ax
    
  printy1:  
    ; loop till y ratio is 0
    inc [diagonal_y1]
    dec [current_y_drew]
    cmp [current_y_drew],0  
    mov ax, [current_x_ratio]
    mov [current_x_drew], ax 
    ; if finished y print the next x
    je printx1
    mov cx, [diagonal_x1]
    mov dx, [diagonal_y1]
    mov [color], 4
    mov al, [color]   
    mov ah, 0ch
    int 10h
    cmp ax, ax
    je printy1
    stop_draw1:
    ret  
    
draw_diagonal_left_to_right endp

draw_diagonal_right_to_left proc
    mov ax, [current_x_ratio]
    mov [current_x_drew], ax
  printx2:  
    dec [diagonal_x1] 
    mov cx, [diagonal_x1]
    mov dx, [diagonal_y1]
    mov [color], 4
    mov al, [color]   
    mov ah, 0ch
    int 10h
             
    mov ax, [diagonal_x1]              
    cmp [diagonal_x2], ax
    je  stop_draw2

    dec [current_x_drew]
    cmp [current_x_drew],0 
    jne printx2
         
    mov ax, [current_y_ratio]
    mov [current_y_drew], ax
    
    printy2:
    inc [diagonal_y1]
    dec [current_y_drew]
    cmp [current_y_drew],0  
    mov ax, [current_x_ratio]
    mov [current_x_drew], ax
    je printx2
    mov cx, [diagonal_x1]
    mov dx, [diagonal_y1]
    mov [color], 4
    mov al, [color]   
    mov ah, 0ch
    int 10h
    cmp ax, ax
    je printy2
    stop_draw2:
    ret  
    
draw_diagonal_right_to_left endp


draw_cube proc
    call clearscreen
    mov [x_center], 160
    mov [y_center], 100
    mov [x1], 50
    mov [y1], 50
    mov ax, [userwidth]
    mov [w], ax
    mov [h], ax
    mov [color],4
    call square1
  
    
    mov [x_center], 190
    mov [y_center], 130
    mov [x1], 75                                                                                                                                             
    mov [y1], 25        
    mov ax, [userwidth]
    mov [w], ax
    mov [h], ax
    call square1
  

   
         
   MOV [diagonal_x1], 75
   MOV [diagonal_y1], 25
   MOV [diagonal_x2], 50
   MOV [diagonal_y2], 50  
   MOV [current_ratio], 1
   call draw_diagonal 
   
   MOV [diagonal_x1], 75
   MOV [diagonal_y1], 25
   MOV [diagonal_x2], 50
   MOV [diagonal_y2], 50
   mov ax, [w]
   add [diagonal_x1], ax
   mov ax, [w]
   add [diagonal_x2], ax       
   
   
  
   call draw_diagonal 
   MOV [diagonal_x1], 75
   MOV [diagonal_y1], 25
   MOV [diagonal_x2], 50
   MOV [diagonal_y2], 50
   mov ax, [h]
   add [diagonal_y1], ax
   mov ax, [h]
   add [diagonal_y2], ax
   call draw_diagonal
   
   
   MOV [diagonal_x1], 75
   MOV [diagonal_y1], 25
   MOV [diagonal_x2], 50
   MOV [diagonal_y2], 50
   mov ax, [w]
   add [diagonal_x1], ax
   mov ax, [w]
   add [diagonal_x2], ax
   mov ax, [h]
   add [diagonal_y1], ax
   mov ax, [h]
   add [diagonal_y2], ax
   call draw_diagonal
   ret
draw_cube endp 



draw_Pyramid proc  
    ; init pyramid size and start point 
    call clearscreen
    mov [x1], 50
    mov [y1], 50
    mov [w], 50
    mov [h], 50
    mov cx, [x1]
    add cx, [w]
    mov dx, [y1]
    mov [color], 4
    mov al, [color]   
    ; draw base line
j1:
    mov ah, 0ch
    int 10h
    dec cx
    cmp cx, [x1]
    ja j1
           
   ; 
   mov [current_ratio] ,1
   mov [x1], 50
   mov [y1], 50
   mov [w], 50
   mov [h], 50  
   
   mov ax, [x1]
   mov [diagonal_x1], ax  
   mov [diagonal_x2], ax
   mov ax, [y1]
   mov [diagonal_y1], ax 
   mov [diagonal_y2], ax
   
   ; finding the pyramid center point (in the middle of the base)
   
   MOV ax, [w]     ;Load numerator in BH  
   xor dx, dx
   MOV bx, 2     ;Load denominator in AL
   DIV bx            ;Divide BH by AL
            
   ; draw pyramid left side
   add [diagonal_x1], ax
   sub [diagonal_y1], ax 
   call draw_diagonal
          
   ; draw pyramid right side (including points values)
   mov [current_x_ratio] ,1
   mov [current_y_ratio] ,1
   mov ax, [x1]
   mov [diagonal_x1], ax  
   mov ax, [y1]
   mov [diagonal_y1], ax 
   mov [diagonal_y2], ax
   
   mov ax, [w]
   add [diagonal_x2], ax
   
   MOV ax, [w]     ;Load numerator in BH  
   xor dx, dx
   MOV bx, 2     ;Load denominator in AL
   DIV bx            ;Divide BH by AL
           
   ; draw the pyramid right side
           
   add [diagonal_x1], ax
   sub [diagonal_y1], ax  
   call draw_diagonal_left_to_right   
   
   ; draw the 3d lines
   mov [current_x_ratio] ,3
   mov [current_y_ratio] ,1
   mov ax, [x1]
   mov [diagonal_x1], ax  
   mov [diagonal_x2], ax
   mov ax, [y1]
   mov [diagonal_y1], ax 
   mov [diagonal_y2], ax 
   add [diagonal_x1], 25
   sub [diagonal_y1], 25 
   add [diagonal_x2], 65
   sub [diagonal_y2], 20
   call draw_diagonal_left_to_right
    
   mov [current_x_ratio] ,5
   mov [current_y_ratio] ,4
    mov [diagonal_x1], 115
   mov [diagonal_y1], 38 
   mov [diagonal_x2], 100
   mov [diagonal_y2], 50
   call draw_diagonal_right_to_left
    
    
    
    
    
    
    ret
draw_Pyramid endp
  
proc twodigits
    lea dx, msg2
    mov ah, 09
    int 21h
    mov ah, 1
    int 21h
    sub al, '0' 
    MOV BL, AL  
    mov bh, 0
    mov [userwidth], bx
    
    mov ah, 1
    int 21h
    cmp al, 0dh
    je updatecube
    
    mov ch, 0
    sub al, '0'
    MOV CL, AL 
   
    MOV bx, [userwidth]
    mov ax, 10
    mul bx
    mov [userwidth], ax  
    add [userwidth], cx
    updatecube:
   ret
twodigits endp  
           
           
proc runupdatedcube
    
   call twodigits
   
   mov [userwidth], ax
   call draw_cube  
   
   ret
   
runupdatedcube endp 

proc clearscreen 
    mov ax, 3
    int 10h
    mov ah, 0
    mov al, 13h
    int 10h
    ret
clearscreen endp 

proc menu
    lea dx,logo ; Print logo
    mov ah,09h
    int 21h
    lea dx, msg1
    mov ah, 09
    int 21h 
    mov ah, 1
    int 21h 
    MOV BL, AL


   cmp bl, 31h 
   je g
   cmp bl, 32h 
   je g2
   mov ax, 1 
   
   cmp ax, 1
   
   je cont
   
   g: 
   call draw_cube 
   call getmouse

   mov ax, 1    
   cmp ax, 1
   je cont
   
   cmp bl, 32h 
   je g2
   g2:
   call draw_pyramid  
    mov ax, 1 
   
   cmp ax, 1
   je cont
   
   cont:    
   ret
menu endp



proc getmouse
    ; Init mouse driver           
    mov ax,0
    int 33h    
    or ax,ax
    jz no_mouse
    ; display mouse cursor:
    mov ax, 1
    int 33h
    
    ; loop till mouse click
    check_mouse_buttons:
    mov ax, 3
    int 33h  
    mov [curx], cx
    mov [cury], dx
    cmp bx, 0 
    je check_mouse_buttons
    
    ; Getting mouse location
    mov [curx], cx
    mov [cury], dx 
    
    ; check if cube size change required
    ; check x axis in cube 
    ; check if mouse location on the left of the cube
    mov ax, [x1]
    cmp [curx], ax
    jb no_change_required  
    ; check if mouse location on the right of the cube
    mov ax, [x1] 
    mov [new_curx], ax
    mov ax, [w]
    add [new_curx], ax 
    mov ax, [curx]  
    cmp [new_curx], ax
    jb no_change_required: 
    
    ; check y axis in cube  
    ; check if mouse location above the cube
    mov ax, [y1]
    cmp [cury], ax
    jb no_change_required
    ; check if mouse location below the cube
    mov ax, [y1] 
    mov [new_cury], ax
    mov ax, [w]
    add [new_cury], ax 
    mov ax, [cury]  
    cmp [new_cury], ax
    jb no_change_required:
    
    ; case mouse in cube redraw cube with new size      
    call clearscreen
    call runupdatedcube         

    no_mouse:       
    no_change_required: 
    ret
getmouse endp    



start:
    mov ax, @DATA
    mov ds, ax

    mov ah, 0
    mov al, mode
    int 10h

    mov [userwidth], 50  
    
    call menu


    mov ax, 4c00h
    int 21h
END start
