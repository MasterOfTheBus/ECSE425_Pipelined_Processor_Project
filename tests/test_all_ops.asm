# This file is meant to test all the instructions that the assembler is required to support
# It's not going to actually do anything

			add $1, $1, $4	# add
			sub $2, $1, $4
			addi $3, $0, 6
			mult $7, $10

label2:			div $3, $8
			slt $12, $5, $9
			slti $8,	$13, 2
			and $10, $14, $15
			or $2, $2,	$6
			nor		$10, $8, $9

label1:		xor $9, $2, $11
	andi $12, $13, 2
		ori $7, $8, 9
			xori $2, $8, 9
			mfhi $12
				mflo $11		# comment
			lui $3 2005
			sll $3,$2,5
			jr $3
			srl $4, $8, 2
	sra $11, $15, 6
			lw $3, 0($12)
			lb $4, 4($10)
			sw $8, 0($2)
			jal label1
			sb $9, 8($9)
			beq $3, $14, label1
			bne $2, $10, label2
			asrt $3, $5
			asrti $6, -99
			halt
			j End

End:	beq $12, $12, End