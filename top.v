module top(clk, rst);
//output overflow, underflow;
input clk, rst;

wire [3:0]OP;

wire [31:0]PC_TOP, ALU_RESULT, ADDR_SRC, A, B, RESULT, DATA, D1, D2, EXT, IN;
localparam c=4;
wire ZERO, IRWRITE, WRITE_REG, ALUSRCA, PC_WRITE, WRITE_MEM, ADDSRC;
wire ALU_MEM;
wire [1:0]ALUSRCB, IMM_TYPE;


register_file REGISTER_FILE(clk, IN[19:15], IN[24:20], D1, D2, IN[11:7], ALU_RESULT, WRITE_REG);

pc PC(PC_TOP, ALU_RESULT, clk, PC_WRITE, rst);

mux2x1 MUX2X1A(PC_TOP, D1, ALUSRCA, A);

mux3x1 MUX3X1B(D2, EXT, c, ALUSRCB, B);

mux2x1 MUX2X1RESULT(RESULT, DATA, ALU_MEM, ALU_RESULT);

mux2x1 MUX2X1ADDRSRC(PC_TOP, ALU_RESULT, ADDSRC, ADDR_SRC);

mem MEM(clk, ADDR_SRC, D2, DATA, WRITE_MEM);

instr_reg INSTR_REG(DATA, clk, IN, IRWRITE);

immext IMMEXT(IN, EXT, IMM_TYPE, clk);

alu ALU(A, B, OP, RESULT, ZERO, overflow, underflow);




control_unit CONTROL_UNIT(
    IN,
    ZERO,
    clk,
    rst,
    WRITE_REG,
    WRITE_MEM,
    ADDSRC,
    IRWRITE,
    ALUSRCA,
    ALUSRCB,
    OP,
    ALU_MEM,
    PC_WRITE,
    IMM_TYPE
);


endmodule


