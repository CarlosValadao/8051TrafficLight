; -----------------------------------------------
; constants
; -----------------------------------------------

data_ptr	data	20h	; number to display
data_len	equ	4h	; number of digits

numbers:
	; Binary codes for displaying digits 0-9 on the 8-segment LED display
	db 01101111b ; 9
	db 01111111b ; 8
	db 00000111b ; 7
	db 01111101b ; 6
	db 01101101b ; 5
	db 01100110b ; 4
	db 01001111b ; 3
	db 01011011b ; 2
	db 00000110b ; 1
	db 00111111b ; 0

	org 0
	ljmp initialize_system

	org 000bh
	ljmp handle_timer_interrupt

	org  0003h
	ljmp handle_external_interrupt_0

	org  0013h
	ljmp handle_external_interrupt_1

;; display the number on the led display
 ;
 ; dptr must point to table numbers
 ; r0 must contain (data_ptr+data_len)
 ;
 ; affected registers: a, b, r0, p1, p3
 ; notes: uses dptr
update_led_display:
	; Decrement r0 to get the next digit
	dec	r0	; in uc
	; Retrieve the digit value from data_ptr and translate it to binary
	mov	a, @r0
	movc	a, @a+dptr

	; Display the digit on the LED display by sending it to p1
	mov	p1, a

	; Decrement r0 again to get the next digit
	dec	r0	; in uc
	; Retrieve the next digit and display it on p0
	mov	a, @r0
	movc	a, @a+dptr
	mov	p0, a
	ret

initialize_system:
	; Initialize data pointers to zeroes for the tens and ones digits
	mov	data_ptr+0, #009h	; tens
	mov	data_ptr+1, #008h	; ones
	mov r5, #00h

	mov p0, #00h
	mov p1, #00h
	mov p2, #00h
	; Initialize dptr to point to the numbers table
	mov	dptr, #numbers
	; Configure external interrupts
	mov ie, #10000111b ;configuração das interrupções externas
	mov ip, #00000101b ;configuração da prioridade da interrupção
	; Set up timer
	mov th0, #0ffh
	mov tl0, #0c3h
	mov tmod, #00000001b
	mov r4, #006h
	mov r6, #000h      ; cars ammount
	mov r3, #002h ; 1 - green; 2 - yellow e 3 - red
	mov b, #00h
	setb tr0

;main loop
main_display_loop:
	; Call the function to update the LED display with the current number
	mov r0, #data_ptr+2
	call update_led_display
	; Keep the loop running indefinitely
	sjmp main_display_loop

; Set the data for yellow light state and turn on the yellow LED
set_yellow_light_state:
	mov data_ptr+0, #006h
	mov data_ptr+1, #009h
	mov r3, #003d
	mov b, #00h
	call turn_on_yellow_light
	ret

; Handle timer interrupt: turn off the timer, process display, and reset it
handle_timer_interrupt:
	clr tr0
	mov r0, #data_ptr+0
	call decrement_display_value
	mov th0, #0ffh
	mov tl0, #0c3h
	mov r1, #data_ptr+0
	cjne @r1, #009h, finalize_timer_interrupt
	mov r1, #data_ptr+1
	cjne @r1, #009h, finalize_timer_interrupt
	; Manage traffic light state based on the timer
	call manage_traffic_light_state
	setb tr0
	mov r0, #data_ptr+2
	reti

; Finalize the timer interrupt by resetting the timer
finalize_timer_interrupt:
	mov r0, #data_ptr+2
	setb tr0
	reti

;; increment the number
 ;
 ; r0 must be set to data_ptr before call
 ;
 ; affected registers: r0
 ; interrupts: none
 ; notes: recursive sub-program
decrement_display_value:
	; Increment the value at data_ptr and check if it reaches 10
	inc	@r0
	cjne	@r0, #00ah, end_decrement_process

	; Reset to 0 when reaching 10 and increment the next position
	mov	@r0, #0
	inc	r0
	inc	@r0
	ret
end_decrement_process:
	ret

; Check the state of the traffic light and handle transitions between green, yellow, and red
manage_traffic_light_state:
	cjne r3, #001d, handle_non_green_light_state
	mov data_ptr+0, #009h
	mov data_ptr+1, #008h
	mov r3, #002d ;yellow
	call turn_on_green_light
	ret

; Handle the yellow and red light states based on the current light
handle_non_green_light_state:
	cjne r3, #003d, set_yellow_light_state
	cjne r5, #00h, handle_emergency_mode
	mov data_ptr+0, #002h
	mov data_ptr+1, #009h
	jmp finalize_red_light_state

; Emergency mode handling: switch to emergency light states
handle_emergency_mode:
	mov r0, #data_ptr+2
	mov data_ptr+0, #004h
	mov data_ptr+1, #008h
	mov r5, #00h
	jmp finalize_red_light_state

; Finalize the red light state and prepare for the next cycle
finalize_red_light_state:
	mov r3, #001h
	mov r2, 00h
	call turn_on_red_light
	ret

; Handle the external interrupt for int0
handle_external_interrupt_0: ;treats int0 (p3.2)
	mov r5, #001h
	cjne r3, #001h, finalize_external_interrupt_0
	mov r0, #data_ptr+2
	mov data_ptr+0, #004h
	mov data_ptr+1, #008h
	mov r5, #00h
	reti

; Finalize external interrupt handling for int0
finalize_external_interrupt_0:
	reti

; Handle the external interrupt for int1
handle_external_interrupt_1: ;treats int1 (p3.3)
	mov r7, a
	mov a, r3
	dec a
	cjne a, #001h, no_action_required
	inc  b
	mov  a, b
	xrl  a, #006h
	jz   increment_vehicle_count
	mov a, r7
	reti

; No action required for this interrupt
no_action_required:
	mov a, r7
	reti

; Increment the vehicle count and update the LED display
increment_vehicle_count:
	mov r0, #data_ptr+2
	mov data_ptr+0, #004h
	mov data_ptr+1, #008h
	call update_led_display
	reti

; Turn on the green light (P2.0) and turn off the other lights
turn_on_green_light:
	clr p2.2
	setb p2.0
	ret

; Turn on the red light (P2.2) and turn off the other lights
turn_on_red_light:
	clr p2.1
	setb p2.2
	ret

; Turn on the yellow light (P2.1) and turn off the other lights
turn_on_yellow_light:
	clr p2.0
	setb p2.1
	ret
end
