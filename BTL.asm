.data
fileName:	.asciiz	"C:/Users/HP/Desktop/Git/FLOAT10.bin"	# dia chi file
int_arr:	.space	64					# Chuoi can sap xep
					#chuoi ban dau:	82,9,50,48,94,42,97,79,40,20,91,51,64,61,26
my_array:	.asciiz	"Chuoi ban dau: "
merge_str:	.asciiz	"merge: "
int_aux:	.space	64		# mang phu / sub-aray
.text
.globl	main
main:
	# Open file
	li $v0, 13
	la $a0, fileName
	li $a1, 0
	li $a2, 0
	syscall
	move $s0, $v0
	# Read from file
	li   $v0, 14
	move $a0, $s0
	la   $a1, int_arr	# Truyen du lieu file vao int_arr
	li   $a2, 64
	syscall
	# Close the file 
	li   $v0, 16
	move $a0, $s0
	syscall
	# In ra chuoi ban dau
	li	$v0, 4
	la	$a0, my_array
	syscall
	li	$v0, 1
	la	$a1, int_arr
	addi	$a2, $a1, 60
	jal	print
	# a0 = address ( arr[0])	a1 = address ( arr[size])
	la	$a0, int_arr
	add	$a1, $a0, 60
	jal	merge
	add	$t0,$0,$0
	j	Kthuc
#--------------------------------------------
merge:	# a0 = address ( arr[low])	a1 = address ( arr[high])
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)		# Luu thanh ghi tra ve
	sw	$a0, 4($sp)		# Luu dia chi array_low / Save address of arr[low]
	sw	$a1, 8($sp)		# Luu dia chi arr_high / Save address of arr[high]
	sub 	$t0, $a1, $a0		# Do dai chuoi truyen vao / Length *4 of array
	ble	$t0, 4, merge_end	# Dieu kien dung / Stop condition
	
	add	$t1,$0,$0
	
	srl	$t0, $t0, 2		# Chia 2 lam tron len / Divide into 2 and round up
	addi	$t0, $t0, 1
	srl	$t0, $t0, 1
	sll	$t0, $t0, 2
	add	$a1, $a0, $t0		# a1 = address ( arr[mid])
	sw	$a1, 12($sp)		# Luu dia chi arr_mid / Save address of arr[mid]

	jal	merge			# De quy voi arr_low -> arr_mid / Recursion with first array low -> mid
	add	$t0,$0,$0

	lw	$a0, 12($sp)		# Gan arr_mid
	lw	$a1, 8($sp)		# Gan arr_high

	jal	merge			# De quy voi arr_mid -> arr_high / Recursion with second array mid-> high
	add	$t0,$0,$0

	lw	$a0, 4($sp)		# Gan arr_low
	lw	$a1, 12($sp)		# Gan arr_mid
	lw	$a2, 8($sp)		# Gan arr_high
	jal	merge_sort		# Ham merge_sort gan 2 chuoi lai / Merge 2 array together
	add	$t0,$0,$0
	li	$v0, 4
	la	$a0, merge_str
	syscall
	la	$a1, int_arr		# In ra chuoi sau khi merge_sort / Print array after merge_sort
	addi	$a2, $a1, 60

	jal	print
	add	$t0,$0,$0
merge_end:				
	lw	$ra, 0($sp)		# Return ko thuc hien merge_sort va print / Return without merge_sort and print
	addi	$sp, $sp, 16
	jr	$ra
	add	$t0,$0,$0
#--------------------------------------------
merge_sort:	# a0= arr_low	a1= arr_mid	a2= arr_high
	la	$a3, int_aux		# Goi mang phu / Call sub-array
	sub	$s0, $a1, $a0		# s0 = length *4 low -> mid
	sub	$s1, $a2, $a1		# s1 = length *4 mid -> high
	add	$s2, $s0, $s1		# s2 = length *4 low -> high
merge_loop:
	beqz	$s0, end_loop		# Dieu kien dung / Stop condition
	beqz	$s1, end_loop		# Dieu kien dung / Stop condition
	lw	$t1, 0($a0)
	lw	$t2, 0($a1)
	sle	$t0, $t1, $t2		# So sanh 2 gia tri dau tien cua 2 chuoi / Compare 2 first value of 2 array
	beqz	$t0,if_false
if_true:
	sw	$t1, 0($a3)		# Gan gia tri vao mang phu / Insert lower value into sub-array
	addi	$a0, $a0, 4
	subi	$s0, $s0, 4
	j	end_if
	add	$t0,$0,$0
if_false:
	sw	$t2, 0($a3)		# Gan gia tri vao mang phu / Insert lower value into sub-array
	addi	$a1, $a1, 4
	subi	$s1, $s1, 4
end_if:
	addi	$a3, $a3, 4
	j	merge_loop
	add	$t0,$0,$0
end_loop:
	beqz	$s0, end_loop1		# Kiem tra cac gia tri con lai cua mang 1 low -> mid / Check remaining value of first array
	lw	$t1, 0($a0)
	sw	$t1, 0($a3)		# Gan cac gia tri con lai vao mang phu / Insert all remaining value of first array
	addi	$a0, $a0, 4
	subi	$s0, $s0, 4
	addi	$a3, $a3, 4
	j	end_loop
	add	$t0,$0,$0
end_loop1:
	beqz	$s1, end_loop2		# Kiem tra cac gia tri con lai cua mang 1 mid-> high / Check remaining value of second array
	lw	$t2, 0($a1)
	sw	$t2, 0($a3)		# Gan cac gia tri con lai vao mang phu / Insert all remaining value of second array
	addi	$a1, $a1, 4
	subi	$s1, $s1, 4
	addi	$a3, $a3, 4
	j	end_loop1
	add	$t0,$0,$0
end_loop2:
	beqz	$s2, end_loop3		# Tu mang phu int_aux ta gan tra lai cho mang int_arr / Assign sub-array to main array
	subi	$a3, $a3, 4
	subi	$a2, $a2, 4
	lw	$t0, 0($a3)
	sw	$t0, 0($a2)
	subi	$s2, $s2, 4
	j	end_loop2
	add	$t0,$0,$0
end_loop3:
	jr	$ra			# return
#--------------------------------------------
print:	# print array
	# a1 = address ( arr[0])	a2 = address ( arr[size])
	li	$v0, 1
print_loop:
	beq	$a1, $a2, end_print
	add	$a0, $0, $0
	lw	$a0, 0($a1)
	li	$v0, 1
	syscall
	addi	$a1, $a1, 4
	addi	$a0, $0,' '
	addi	$v0, $0, 11
	syscall
	j	print_loop
end_print:
	addi	$a0, $0, '\n'
	addi	$v0, $0, 11
	syscall
	jr	$ra
#ket thuc chuong trinh (syscall)
Kthuc:	addiu	$v0, $zero, 10
	syscall
