#realizado por Nelson Mosquera
#Macro para finalizar el programa
.macro Fin
	li $v0, 10
	syscall
.end_macro 

#Macro para imprimir cualquier cadena
.macro Imprimir(%dirTexto)
	li $v0, 4
	la $a0, %dirTexto
	syscall
.end_macro 

#Macro para hacer una espera de t milisegundos
.macro Delay(%t)
	li $v0, 32	#Llamada al sistema tipo Sleep
	li $a0, %t
	syscall	
.end_macro 

#Macro para apuntar a una coordenada determinada, iniciando en (0,0)
.macro UbicarCoordenada(%x, %y, %base)
	sll %x, %x, 2		#x*16
	sll %y, %y, 2   	#y*16
	sll %y, %y, 5		#y*32
	add %base, %base, %x
	add %base, %base, %y
.end_macro 

#Macro para dibujar un punto de cualquier color, en una coordenada <x,y>, con respecto a una direccion base
.macro DibujarPunto(%x, %y, %base, %color)
	add $t0, $zero, %x
	add $t1, $zero, %y
	addi $t2, $zero, %base
	add $t3, $zero, %color
	UbicarCoordenada($t0, $t1, $t2)
	sw $t3, 0($t2)
.end_macro 

#Macro para dibujar una recta horizontal de determinada longitud
.macro DibujarLineaH(%x, %y, %base, %color, %long)
	addi $t0, $zero, %x
	add $t1, $zero, %y
	add $t2, $zero, %base
	add $t3, $zero, %color
	add $t4, $zero, %long
	UbicarCoordenada($t0, $t1, $t2)
	li $t5, 1	#Iniciar contador
loopDlh:
	sw $t3, 0($t2)		#Dibujar punto
	add $t5, $t5, 1		#Incrementar contador de longitud
	add $t2, $t2, 4		#Siguiente pixel en x
	Delay (5 )
	ble $t5, $t4, loopDlh
.end_macro

#Macro para dibujar una recta vertical de determinada longitud
.macro DibujarLineaV(%x, %y, %base, %color, %long)
	addi $t0, $zero, %x
	addi $t1, $zero, %y
	addi $t2, $zero, %base
	addi $t3, $zero, %color
	addi $t4, $zero, %long
	UbicarCoordenada($t0, $t1, $t2)
	li $t5, 1	#Iniciar contador
loopDlv:
	sw $t3, 0($t2)		#Dibujar punto
	add $t5, $t5, 1		#Incrementar contador de longitud
	add $t2, $t2, 256	#Siguiente pixel en y
	Delay (5) 		
	ble $t5, $t4, loopDlv
.end_macro

#Macro para pintar el Bitmap Display de un solo color
.macro BorrarPantalla(%base, %color)
	addi $t0, $zero, %base
	add $t1, $zero, %color
	li $t2, 1		#Iniciar contador
loopBorrar:
	sw $t1, 0($t0)	#Dibujar punto negro
	add $t2, $t2, 1
	add $t0, $t0, 4	#Siguiente pixel
	Delay (1)
	ble $t2, 4096, loopBorrar
.end_macro 
#Macro para ubicar el color
.macro UbicarColor ( %x , %y , %base )
	add $t0, $zero, %x
	add $t1, $zero, %y
	addi $t2, $zero, %base
	addi $t4, $zero, 0
	UbicarCoordenada($t0, $t1, $t2)
	lw $t4, 0($t2)
.end_macro
#MENSAJE DE BIENBENIDA 
.macro logo()
	BorrarPantalla (BASE_DISPLAY , BLANCO) 
	DibujarLineaV(1,0,BASE_DISPLAY,VERDE,20)
	DibujarLineaV(30,0,BASE_DISPLAY,VERDE,20)
	DibujarLineaV(0,0,BASE_DISPLAY,VERDE,20)
	DibujarLineaV(31,0,BASE_DISPLAY,VERDE,20)
	DibujarLineaH(0,16,BASE_DISPLAY,NEGRO,32)
	DibujarLineaV(16,0,BASE_DISPLAY,NEGRO,32)
	DibujarLineaV(16,1,BASE_DISPLAY,NEGRO,32)
	DibujarLineaH(0,1,BASE_DISPLAY,MORADO,32)
	DibujarLineaH(0,30,BASE_DISPLAY,MORADO,32)
	DibujarLineaH(0,0,BASE_DISPLAY,MORADO,32)
	DibujarLineaH(0,31,BASE_DISPLAY,MORADO,32)
	DibujarPunto(25,8,BASE_DISPLAY,AZUL)
	DibujarPunto(25,7,BASE_DISPLAY,AZUL)
	DibujarPunto(8,25,BASE_DISPLAY,AZUL)
	DibujarPunto(8,26,BASE_DISPLAY,AZUL)
	DibujarPunto(8,8,BASE_DISPLAY,AZUL)
	DibujarPunto(7,8,BASE_DISPLAY,AZUL)
	DibujarPunto(25,25,BASE_DISPLAY,AZUL)
	DibujarPunto(24,25,BASE_DISPLAY,AZUL)
	
	
.end_macro 
.macro DibujarPunto1(%x, %y, %base, %color)	#NUEVO
	addi $t2, $zero, %base			#NUEVO
	addi $t3, $zero, %color			#NUEVO
	UbicarCoordenada(%x, %y, $t2)		#NUEVO
	sw $t3, 0($t2)				#NUEVO
.end_macro 					#NUEVO
#Macro para dibujar una recta horizontal de determinada longitud
.macro BorrarPantallafin(%base, %color)
	addi $t0, $zero, %base
	add $t1, $zero, %color
	li $t2, 1		#Iniciar contador
loopBorrar1:
	sw $t1, 0($t0)	#Dibujar punto negro
	add $t2, $t2, 1
	add $t0, $t0, 8	#Siguiente pixel
	Delay (1)
	ble $t2, 4096, loopBorrar1
.end_macro 
.macro liniahorizontalintercalada()
	li $t6 , 0    
looper:
	DibujarLineaH(0,$t6,BASE_DISPLAY,NEGRO,64)
	addi $t6 , $t6 , 2
	ble $t6, 63, looper
.end_macro 




