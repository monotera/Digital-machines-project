#realizado por Nelson Mosquera
#para displays de:
#until width/height in pixels 16
#Display width/height in pixels 512
#base address for display 0x10000000 (global data)

.include "Macros_proyecto.asm"
	.data #Declaracion de Datos
	.eqv    MORADO          0x00CD6AEE
	.eqv	BASE_DISPLAY	0x10000000
	.eqv	ROJO		0x00FF0000
	.eqv	VERDE		0x0000FF00
	.eqv	AZUL		0x000000FF
	.eqv	NEGRO		0x00000000
	.eqv    BASE_2          0x00C8F1F3
	.eqv    AMARILLO        0x00EBFF09
	.eqv    BLANCO          0x00FFFFFF
	.eqv	T_ESPERA_MS	2000
	#Mensajes de dialogos
	oprima: .asciiz "\n Bienvenido, oprima cualquier tecla para continuar \n"
	mensaje_color: .asciiz "\n su color es: "
	dibujando: .asciiz "\n \t Dibujando....\n" 
	blanco: .asciiz " blanco \n"
	negro: .asciiz " negro \n"
	amarillo: .asciiz " amarillo \n"
	azul: .asciiz " azul \n"
	verde: .asciiz " verde \n"
	validar_m: .asciiz "\n opcion invalida, vuelva a intentar \n"
	preguntar_xi: .asciiz "\n digite cordenada x de inicio \n"
	preguntar_xf: .asciiz "\n digite cordenada x de final \n"
	preguntar_yi:	.asciiz "\n digite cordenada y de inicio \n"
	preguntar_yf:	.asciiz "\n digite cordenada y de final \n"
	mensaje_final: .asciiz "fin del programa \n"
	lapizarriba: .asciiz "\n \t Lapiz arriba !\n" 
	menu: .asciiz " \n Bienvenido al menu \n escoja una opcion: \n 1)dibujar a mano alzada \n 2)dibujar linea \n 3)salir \n "  
	.text
pre_main:
	logo()							#imprime el logo
	Imprimir(oprima)					#imprime mensaje de bienvenida
	jal leerchar				
	BorrarPantalla (BASE_DISPLAY , BLANCO)			#poner la pantalla en blanco

main:
	Imprimir(menu)			   		        # Imprime el menu principal
	jal leerNumero  					# Llamado a la funcion de leer un numero
	beq $s4 , 1 , dibujar_mano				# Si la opcion es 1 lleva al modo de dibujo mano alzada
        beq $s4 , 2 , dibujar_linea                  		# Si la opcion es 2 lleva al modo de dibujo de lineas
	beq $s4 , 3 , salir1					# Si la opcion es 3 termina el programa
	bgt $s4,3,validar					#validar respuesta
	blt $s4,1,validar					
salir1:

	BorrarPantalla (BASE_DISPLAY , NEGRO)			# Volver la pantalla a negro
	Imprimir(mensaje_final)					# Imprime un mensaje de despedida
	Fin							# Llamado a la macro de fin de programa
								
validar:
	Imprimir(validar_m)
	j main
dibujar_mano:
	
	li $a0 , 0
	li $a1 , 0
	li $a2 , 0
	li $a3 , 0
        addi $a2 , $a2 , 1					# Inicializa bandera para bajar o subir lapiz
        addi $s6 , $s6 , 0					# Inicializa contador para cambio de color
        addi $t8 , $zero , 0					# Inicializa bandera para borrar
        addi $k1 , $zero , 0 					# Inicializa bandera principal para borrar
	addi $s5 , $zero , NEGRO				# Inicializa color base del puntero
	addi $s2 , $zero , 0					# Inicializa coordenadas de x 
	addi $s3 , $zero , 0					# Inicializa coordenadas de y
	addi $a1 , $zero , 5					# Inicializa coordenadas de x anterior
	addi $a3 , $zero , 5					# Inicializa coordenadas de y anter
	Imprimir (lapizarriba) 
	jal fondoBlanco                                  	# Imprime el primer estado del lapiz , que es laipz arriba
	
fondoBlanco:
	li $s6 , 0 	
	add $s1 , $zero ,BLANCO					# Agrega al color de fondo el BLANCO
	add $s7 , $zero ,BLANCO					# Agrega al color anterior el BLANCO 
	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )   		# Guarda el color en las coordenadas anteriores , osea el de fondo 
	j cursor   						# Salto a la etiqueta principal del cursor
cursor:
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5 )		# Dibuja un punto en las coordenadas x , y actuales del color actual
	jal leerchar						# Lee un caracter para saber la accion a realizar
	add $k0 , $t0 , $zero					# Agrega la informacion leida en t0 al registo k0
	beq $k0 , 99 , color1					# Si se digito c , se salta ala etiqueta de cambio de color
	beq $k0 , 122 , borrarcompleto				# Si se digito z , se salta a la etiqueta de borrar toda la pantalla
	beq $k0 , 113 , volveralmain				# Si de digito q , se salta a la etiquetal del menu principal
	beq $k0 , 98 , bajarsubir				# Si se digito b , se activa la funcion de dibujar o levantar lapiz
	beq $a2 , 0 , bajar					# Si el valor de a2  es 0 se dibuja
	beq $a2 , 1 , subir					# Si el valor de a2 es 1 , se deja levantado el lapiz
w1:
	addi $s2 , $s2 , 0					# Se dejan los valores de x como estan
	ble $s3 , 0 , coordenadacero
	addi $s3 , $s3 , -1					# Se decrementa y para subir el cursor				# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero	
	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor						# Se salta a la etiqueta principal del cursor
a1:
	ble $s2 , 0 , coordenadacerox
	addi $s2 , $s2 , -1					# Se decrementa x para mover el cursor a la izquierda
	addi $s3 , $s3 , 0					# Se dejan los valores de y como estan
	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor						# Se salta a la etiqueta principal del cursor
s1:
	addi $s2 , $s2 , 0					# Se dejan los valores de x como estan
	bge $s3 , 63 , coordenadaultima
	addi $s3 , $s3 , 1					# Se incrementa y para subir el cursor					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero
	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor						# Se salta a la etiqueta principal del cursor
d1: 
	bge $s3 , 64 , coordenadacerox
	addi $s2 , $s2 , 1					# Se incrementa x para mover el cursor a la derecha
	addi $s3 , $s3 , 0					# Se dejan los valores de y como estan
	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor						# Se salta a la etiqueta principal del cursor
color1:
	addi $s6 , $s6 ,1					# Suma 1 , al contador de color
	beq $s6 ,1, c1						# Si el contador es 1 , coloca el 1 color
	beq $s6 ,2, c2						# Si el contador es 2 , coloca el 2 color
	beq $s6 ,3, c3						# Si el contador es 3 , coloca el 3 color
	beq $s6 ,4, c4						# Si el contador es 4 , coloca el 4 color
	beq $s6 ,5, c5						# Si el contador es 5 , coloca el 5 color
	beq $s6 ,6, c6						# Si el contador es 6 , Se reinicia y vuelve a ser 0
	j cursor
c1:
	addi $s5 , $zero , BLANCO
	Imprimir(mensaje_color)					# Agrega al color actual el rojo
	Imprimir(blanco)					# imprime en consola el color
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5 )		# Dibuja el punto del color actual 
	j cursor						# Regresa a la etiqueta principal del cursor
c2:
	addi $s5 , $zero , VERDE
	Imprimir(mensaje_color)					# Agrega al color actual el verde
	Imprimir(verde)						# imprime el nombre del color
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5 )		# Dibuja el punto del color actual 
	j cursor						# Regresa a la etiqueta principal del cursor
c3:
	addi $s5 , $zero , AZUL	
	Imprimir(mensaje_color)					# Agrega al color actual el azul
	Imprimir(azul)						# imprime el nombre del color 
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5 )		# Dibuja el punto del color actual
	j cursor						# Regresa a la etiqueta principal del cursor
c4:
	addi $s5 , $zero , AMARILLO
	Imprimir(mensaje_color)					# Agrega al color actual el amarillo
	Imprimir(amarillo)					# imprime el nombre del color
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5 )		# Dibuja el punto del color actual 
	j cursor						# Regresa a la etiqueta principal del cursor

c5:
	addi $s5 , $zero , NEGRO
	Imprimir(mensaje_color)					# Agrega al color actual el negro
	Imprimir(negro)						# imprime el nombre del color
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5 )		# Dibuja el punto del color actual 
	j cursor 						# Regresa a la etiqueta principal del cursor
c6: 
	addi $s6 , $zero , 0					# Reinicia contador de color en 0
	j color1						# Vuelve a la etiqueta de cambio de color 
bajarsubir:
	beq $a2 ,0, bajar1					# Si la bandera esta en 0 , salta a la etiqueta de activar la funcion de dibujar
	beq $a2 ,1, subir1					# Si la bandera esta en 1 , salta a la etiqueta de activar la funcion de subir el lapiz
	j cursor						# Salta de nuevo a la etiqueta de cursor principal por si ocurre algun error
bajar1:
	Imprimir (lapizarriba)					# Imprime el proximo estado que es lapiz arriba
	addi $a2 , $zero ,1					# Cambia el estado de la bandera a 1 
	j cursor 						# Regresa a la etiqueta principal de cursor 
subir1:
	Imprimir(dibujando)					# Imprime el proximo estado del cursor , que es dibujando 
	addi $a2 , $zero ,0					# Cambia el estado de la bandera a 0
	j cursor						# Regresa a la etiqueta principal de cursor 
bajar:
	add $s7 , $zero , $s5					# Agrega al registro $s7 , el color actual			
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s7)			# Dibuja el punto del color actual en las coordenadas actuales
	beq $k0 , 119 , w1					# Si en $k0 esta guardado el ascci de w va hacia arriba
	beq $k0 , 115 , s1					# Si en $k0 esta guardado el ascci de s va hacia abajo
	beq $k0 , 97 , a1					# Si en $k0 esta guardado el ascci de a va hacia la izquierda
	beq $k0 , 100 , d1					# Si en $k0 esta guardado el ascci de d va hacia la derecha
subir:
 	DibujarPunto($s2,$s3,BASE_DISPLAY, $t4 )		# Dibuja el punto del color de la coordenada anterior en las coordenadas actuales
	beq $k0 , 119 , w1					# Si en $k0 esta guardado el ascci de w va hacia arriba
	beq $k0 , 115 , s1					# Si en $k0 esta guardado el ascci de s va hacia abajo
	beq $k0 , 97 , a1					# Si en $k0 esta guardado el ascci de a va hacia la izquierda
	beq $k0 , 100 , d1					# Si en $k0 esta guardado el ascci de d va hacia la derecha

borra2: 
	Imprimir (lapizarriba)					# Imprime el estado actual como lapiz arriba
	addi $k1 , $zero , 0					# DesActiva la bandera k1 de borrar para empezar a borrar
	addi $t8 , $zero , 0					# Cambia el estado de la bandera t8 de borrar 
	j cursor						# Regresa a la etiqueta principal del cursor
borrar:
	add $s7 , $zero , $s1					# Agrega al color actual , el color del fondo 
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s7)			# Dibuja un punto del color del fondo en las coordenadas actuales
	beq $k0 , 119 , w1					# Si en $k0 esta guardado el ascci de w va hacia arriba
	beq $k0 , 115 , s1					# Si en $k0 esta guardado el ascci de s va hacia abajo
	beq $k0 , 97 , a1					# Si en $k0 esta guardado el ascci de a va hacia la izquierda
	beq $k0 , 100 , d1					# Si en $k0 esta guardado el ascci de d va hacia la derecha
	j cursor 						# Salto a la etiqueta principal del cursor 
borrarcompleto:
	BorrarPantalla (BASE_DISPLAY , BLANCO)			# Llamado a la macro de borrar pantalla completa 
	j cursor						# Vulve a la etiqueta principal de cursor 
volveralmain:
	j main							# Vuelve al menu principal
								#Funciones
leerNumero:
	li $v0,5						#Llamada para leer entero
	syscall							# Syscall
	li $s4 , 0						# Carga en s4 , el valor 0
	add $s4,$v0,$zero					# Agrga al registro s4 lo que se lee
        jr $ra							# Salto al lugar de donde fue llamado						
leerchar:
	li $v0,12						#Llamada para leer entero
	syscall							# Syscall
	add $t0, $v0, $zero					# Agrega al registro s4 lo que se lee
        jr $ra							# Regresa a la etiqueta  de la  cual fue llamado
coordenadacero:
	li $t4 , 0
 	li $s3 , 63
 	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero	
 	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor
coordenadaultima:
	li $t4 , 0
	li $s3 ,  0
 	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero	
 	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor
coordenadacerox:
	li $t4 , 0
 	li $s2 , 63
 	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero	
 	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor
coordenadaultimax:
	li $t4 , 0
	li $s2 ,  0
 	add $a1 , $s2 , $zero					# Se guarda en los registros  de pocision anteriores la nueva pocision
	add $a3 , $s3 , $zero	
 	UbicarColor( $a1 , $a3 ,BASE_DISPLAY )			# Se guarda en el registro de $t4 el color de esta pocision 
	j cursor


dibujar_linea:
	
	Imprimir(preguntar_xi)
	jal leerNumero
	li $s0 , 0						# Carga en s0 , el valor 0
	add $s0,$s4,$zero					# Agrega al registro s0 lo que se lee
	Imprimir(preguntar_yi)
	jal leerNumero
	li $s1 , 0						# Carga en s1 , el valor 0
	add $s1,$s4,$zero					# Agrega al registro s1 lo que se lee
	Imprimir(preguntar_xf)
	jal leerNumero
	li $s2 , 0						# Carga en s2 , el valor 0
	add $s2,$s4,$zero					# Agrega al registro s2 lo que se lee
	Imprimir(preguntar_yf)
	jal leerNumero
	li $s3 , 0						# Carga en s3 , el valor 0
	add $s3,$s4,$zero					# Agrega al registro s3 lo que se lee
	li $s6,0						# contador = 0
	li $t8,0
	li $t9,0						
	beq $s1,$s3,horizontal					# aqui se decide si la linea es horizontal
	beq $s0,$s2,vertical					# aqui se decide si la linea es vertical
	jal pendiente						#aqui se decide si la linea es diagonal


pendiente: 
	sub $t8,$s3,$s1						#t8 = y2-y1 
	sub $t9,$s2,$s0						#t9 = x2-x1
	div $t9,$t8,$t9						#m=t8/t9
	bge $t9,0,diagonal_neg
	jal diagonal_pos

diagonal_neg:
	blt $s0,$s2,diagonal_ba
	bgt $s0,$s2,diagonal_ab
	j main
diagonal_ba:
	DibujarPunto($s0,$s1,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s0, $s0, 1	
	add $s1, $s1, 1
	blt $s6,$s2,diagonal_ba
	j main
diagonal_ab:
	DibujarPunto($s0,$s1,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	sub $s0, $s0, 1	
	sub $s1, $s1, 1
	blt $s6,$s2,diagonal_ab
	j main 
diagonal_pos:
	blt $s0,$s2,diagonal_b
	bgt $s0,$s2,diagonal_a
	j main 
diagonal_a:
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s2, $s2, 1	
	sub $s3, $s3, 1
	blt $s6,$s0,diagonal_a
	j main
diagonal_b:
	DibujarPunto($s0,$s1,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s0, $s0, 1	
	sub $s1, $s1, 1
	blt $s6,$s2,diagonal_b
	j main
vertical:
	blt $s1,$s3,vertical_abajo
	bgt $s1,$s3,vertical_arriba
	j main	
	
vertical_arriba:
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s3, $s3, 1
	blt $s6,$s1,vertical_arriba
	j main

vertical_abajo:
	DibujarPunto($s0,$s1,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s1, $s1, 1
	blt $s6,$s3,vertical_abajo
	j main

horizontal:
								#aqui se decide hacia donde se va a dibujar la linea horizontal
	blt $s0,$s2,horizontal_derecha				
	bgt $s0,$s2,horizontal_iz
	j main	

horizontal_derecha:
	DibujarPunto($s0,$s1,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s0, $s0, 1						#Incrementa X
	blt $s6,$s2,horizontal_derecha				
	j main

horizontal_iz:
	DibujarPunto($s2,$s3,BASE_DISPLAY, $s5)			# Dibuja un punto en las coordenadas x , y actuales del color actual
	add $s6, $s6, 1						#Incrementar contador de longitud
	add $s2, $s2, 1						#Incrementa X
	blt $s6,$s0,horizontal_iz
	j main
