module pc(pc, pc_next, clk, pc_write, rst);
input clk, pc_write;
input [31:0]pc_next;
output reg [31:0]pc;
input rst;
always @(posedge clk)
begin
	if(rst)
		pc<=0;
	else if(pc_write)
		pc<=pc_next;
	else
		pc<=pc;
end
endmodule
