module instr_reg(in, clk, out, enb);

input [31:0]in;
output reg [31:0]out;
input clk, enb;

always @(posedge clk)
begin
	if(enb)
		out<=in;
	else
		out<=out;
end
endmodule
