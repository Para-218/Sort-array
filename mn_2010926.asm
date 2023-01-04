	.data
int_n:		.word	0
binaryInput:	.asciiz	"Ket qua he 2: "
binarySpace:	.space	17
decimalInput:	.asciiz	"Ket qua he 10: "
decimalSpace:	.space	6
hexInput:	.asciiz	"Ket qua he 16: "
hexSpace:	.space	5
nl:		.asciiz	"\n"
hexDigit:	.asciiz	"0123456789ABCDEF"

fileName:	.asciiz	"C:/Users/HP/Desktop/CHUOISO.txt"
	.text
	.globl  main
main:
	addi    $v0, $0, 30		# syscall 30
	syscall
	move	$s1, $a0

	addi	$v0, $0, 40		# syscall 40
	addi	$a0, $0, 0
	add	$a1, $0, $s1
        syscall

	addi	$v0, $0, 42		# syscall 42
	addi	$a0, $0, 0
	addi	$a1, $0, 65536		# < 65536
	syscall
	sw	$a0, int_n
	lw	$s0, int_n
	# In ra ket qua he 2
	li	$a1, 16		# a1=do dai bit
	jal	prtbin
	# In ra ket qua he 10
	li	$a1, 5		# a1=do dai con so
	jal	prtdec
	# In ra ket qua he 16
	li	$a1, 16		# a1=do dai bit
	jal	prthex

	# Open
	li $v0, 13
	la $a0, fileName
	li $a1, 1
	li $a2, 0
	syscall
	move $s1, $v0

	# Write binary number
	li   $v0, 15
	move $a0, $s1
	la   $a1, binaryInput
	li   $a2, 14
	syscall
	
	li   $v0, 15
	move $a0, $s1
	la   $a1, binarySpace
	li   $a2, 16
	syscall
	
	li   $v0, 15
	move $a0, $s1
	la   $a1, nl
	li   $a2, 1
	syscall
	
	# Write decimal number
	li   $v0, 15
	move $a0, $s1
	la   $a1, decimalInput
	li   $a2, 15
	syscall
	
	li   $v0, 15
	move $a0, $s1
	la   $a1, decimalSpace
	li   $a2, 5
	syscall
	
	li   $v0, 15
	move $a0, $s1
	la   $a1, nl
	li   $a2, 1
	syscall
	
	# Write hex number
	li   $v0, 15
	move $a0, $s1
	la   $a1, hexInput
	li   $a2, 15
	syscall
	
	li   $v0, 15
	move $a0, $s1
	la   $a1, hexSpace
	li   $a2, 4
	syscall

	# Close the file 
	li   $v0, 16
	move $a0, $s1
	syscall

	j	Kthuc
#-------------------------------------
prtbin:
	# a1 = do dai bit	a2 = buoc nhay	t7 = 0001	t6 = dia chi luu char so	t5 = number
	li	$t7, 1

	la	$t6, decimalInput	# dia chi cuoi cung cua binarySpace: binarySpace[length]
	subu	$t6, $t6, 1
	sb	$0, 0($t6)		# luu 0 la diem ket thuc cua chuoi

	lw	$t5, int_n		# lay gia tri
	
prtbin_loop:
	and	$t0, $t5, $t7		# lay binary dau tien cua con so
	la	$a3, hexDigit
	add	$a3, $a3, $t0
	lb	$t0, 0($a3)		# truy xuat ra char tuong ung

	subu	$t6, $t6, 1		# dich dia chi sang ben trai
	sb	$t0, 0($t6)		# luu ky tu vao

	srl	$t5, $t5, 1		# dich 1 bit sang trai de lay ky tu tiep theo
	subi	$a1, $a1, 1		# do dai bit -1
	bgtz    $a1, prtbin_loop	# loop

	jr	$ra                     # return
#-------------------------------------
prtdec:
	# t0 = number
	lw	$t0, int_n
	li	$a1, 5

	la	$t6, hexInput		# dia chi cuoi cung cua decimalSpace: decimalSpace[length]
	subu	$t6, $t6, 1
	sb	$0, 0($t6)
dec_loop:
	div	$t0, $t0, 10		# chia 10
	mfhi	$t1			# t1 = so du
	mflo	$t0			# t0 = thuong so
	
	la	$a3, hexDigit
	add	$a3, $a3, $t1
	lb	$t1, 0($a3)		# truy xuat ra char tuong ung tu so du $t1

	subu	$t6, $t6, 1		# dich dia chi sang ben trai
	sb	$t1, 0($t6)		# luu ky tu vao
	subi	$a1, $a1, 1		# do dai con so can in -1
	bnez	$a1, dec_loop

	jr	$ra                     # return
#-------------------------------------
prthex:
	# a1 = do dai bit	a2 = buoc nhay	t7 = 1111	t6 = dia chi luu char so	t5 = number
	li	$t7, 15			# t7 = 0000 1111

	la	$t6, nl			# dia chi cuoi cung cua hexSpace: hexSpace[length]
	subu	$t6, $t6, 1
	sb	$zero, 0($t6)		# luu 0 la diem ket thuc cua chuoi

	lw	$t5, int_n		# lay gia tri
	
prthex_loop:
	and	$t0, $t5, $t7		# lay binary dau tien cua con so
	la	$a3, hexDigit
	add	$a3, $a3, $t0
	lb	$t0, 0($a3)		# truy xuat ra char tuong ung

	subu	$t6, $t6, 1		# dich dia chi sang ben trai
	sb	$t0, 0($t6)		# luu ky tu vao

	srl	$t5, $t5, 4		# dich 1 bit sang trai de lay ky tu tiep theo
	subi	$a1, $a1, 4		# do dai bit -1
	bgtz    $a1, prthex_loop	# loop

	jr	$ra			# return
Kthuc:
	li	$v0, 10
	syscall
