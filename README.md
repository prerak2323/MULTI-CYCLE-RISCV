# MULTI-CYCLE-RISCV

<img src = "RISCV.jpg">

1. R-Type (Register-Register)
Used for arithmetic and logical operations with three register operands.

Field	Bits	Description
opcode	7	Basic operation (e.g., add)
rd	5	Destination register
funct3	3	Sub-operation code
rs1	5	Source register 1
rs2	5	Source register 2
funct7	7	Additional sub-operation code
2. I-Type (Immediate)
Used for instructions with immediate values (e.g., addi, lw, jalr).

Field	Bits	Description
opcode	7	Basic operation
rd	5	Destination register
funct3	3	Sub-operation code
rs1	5	Source register 1
imm[11:0]	12	Immediate value (signed)
3. S-Type (Store)
Used for store instructions (e.g., sw).

Field	Bits	Description
opcode	7	Basic operation
imm[4:0]	5	Immediate value (lower bits)
funct3	3	Sub-operation code
rs1	5	Source register 1
rs2	5	Source register 2
imm[11:5]	7	Immediate value (upper bits)
The immediate is formed by concatenating imm[11:5] and imm[4:0].

4. B-Type (Branch)
Used for branch instructions (e.g., beq, bne).

Field	Bits	Description
opcode	7	Basic operation
imm[11]	1	Immediate value (bit 11)
imm[4:1]	4	Immediate value (bits 4–1)
funct3	3	Sub-operation code
rs1	5	Source register 1
rs2	5	Source register 2
imm[10:5]	6	Immediate value (bits 10–5)
imm[12]	1	Immediate value (bit 12)
The immediate is formed as {imm[12], imm[10:5], imm[4:1], imm[11], 0} (offset).

5. U-Type (Upper Immediate)
Used for instructions that set the upper 20 bits of a register (e.g., lui, auipc).

Field	Bits	Description
opcode	7	Basic operation
rd	5	Destination register
imm[31:12]	20	Immediate value (upper bits)
6. J-Type (Jump)
Used for jump instructions (e.g., jal).

Field	Bits	Description
opcode	7	Basic operation
rd	5	Destination register
imm[20]	1	Immediate value (bit 20)
imm[10:1]	10	Immediate value (bits 10–1)
imm[11]	1	Immediate value (bit 11)
imm[19:12]	8	Immediate value (bits 19–12)
The immediate is formed as {imm[20], imm[10:1], imm[11], imm[19:12], 0} (offset).

Summary Table
Format	Fields
R-Type	opcode (7), rd (5), funct3 (3), rs1 (5), rs2 (5), funct7 (7)
I-Type	opcode (7), rd (5), funct3 (3), rs1 (5), imm (12)
S-Type	opcode (7), imm[4:0] (5), funct3 (3), rs1 (5), rs2 (5), imm[11:5] (7)
B-Type	opcode (7), imm[11] (1), imm[4:1] (4), funct3 (3), rs1 (5), rs2 (5), imm[10:5] (6), imm[12] (1)
U-Type	opcode (7), rd (5), imm[31:12] (20)
J-Type	opcode (7), rd (5), imm[20], imm[10:1] (10), imm[11] (1), imm[19:12] (8)
Let me know if you'd like an explanation or example of specific instructions!





You said:
also provide instruction set categorized as instruction format
ChatGPT said:
ChatGPT
Here is a breakdown of the RISC-V instruction set, categorized based on their instruction format:

1. R-Type Instructions
R-Type instructions are used for register-to-register operations, typically arithmetic or logical.

Instruction	Description	Opcode	funct3	funct7
add rd, rs1, rs2	Add	0110011	000	0000000
sub rd, rs1, rs2	Subtract	0110011	000	0100000
sll rd, rs1, rs2	Shift left logical	0110011	001	0000000
slt rd, rs1, rs2	Set less than	0110011	010	0000000
sltu rd, rs1, rs2	Set less than unsigned	0110011	011	0000000
xor rd, rs1, rs2	Exclusive OR	0110011	100	0000000
srl rd, rs1, rs2	Shift right logical	0110011	101	0000000
sra rd, rs1, rs2	Shift right arithmetic	0110011	101	0100000
or rd, rs1, rs2	OR	0110011	110	0000000
and rd, rs1, rs2	AND	0110011	111	0000000
2. I-Type Instructions
I-Type instructions are used for immediate arithmetic, memory loads, and some control flow.

Instruction	Description	Opcode	funct3
addi rd, rs1, imm	Add immediate	0010011	000
slti rd, rs1, imm	Set less than immediate	0010011	010
sltiu rd, rs1, imm	Set less than immediate, unsigned	0010011	011
xori rd, rs1, imm	XOR immediate	0010011	100
ori rd, rs1, imm	OR immediate	0010011	110
andi rd, rs1, imm	AND immediate	0010011	111
slli rd, rs1, imm	Shift left logical immediate	0010011	001
srli rd, rs1, imm	Shift right logical immediate	0010011	101
srai rd, rs1, imm	Shift right arithmetic immediate	0010011	101
jalr rd, rs1, imm	Jump and link register	1100111	000
lb rd, imm(rs1)	Load byte	0000011	000
lh rd, imm(rs1)	Load halfword	0000011	001
lw rd, imm(rs1)	Load word	0000011	010
lbu rd, imm(rs1)	Load byte unsigned	0000011	100
lhu rd, imm(rs1)	Load halfword unsigned	0000011	101
3. S-Type Instructions
S-Type instructions are used for storing data to memory.

Instruction	Description	Opcode	funct3
sb rs2, imm(rs1)	Store byte	0100011	000
sh rs2, imm(rs1)	Store halfword	0100011	001
sw rs2, imm(rs1)	Store word	0100011	010
4. B-Type Instructions
B-Type instructions are used for conditional branching.

Instruction	Description	Opcode	funct3
beq rs1, rs2, imm	Branch if equal	1100011	000
bne rs1, rs2, imm	Branch if not equal	1100011	001
blt rs1, rs2, imm	Branch if less than	1100011	100
bge rs1, rs2, imm	Branch if greater or equal	1100011	101
bltu rs1, rs2, imm	Branch if less than, unsigned	1100011	110
bgeu rs1, rs2, imm	Branch if greater or equal, unsigned	1100011	111
5. U-Type Instructions
U-Type instructions are used for instructions that set upper immediate bits.

Instruction	Description	Opcode
lui rd, imm	Load upper immediate	0110111
auipc rd, imm	Add upper immediate to PC	0010111
6. J-Type Instructions
J-Type instructions are used for unconditional jumps.

Instruction	Description	Opcode
jal rd, imm	Jump and link	1101111
