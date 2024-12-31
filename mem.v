module mem(clk, addr, din, rd, we);

input [31:0]addr;
input [31:0]din;
output [31:0]rd;
input clk;
input we;

reg [31:0]mem[1023:0];

always @(posedge clk)
begin
	if(we)
		mem[addr]<=din;
		
end

assign rd = mem[addr];

initial 
begin
      //  mem[0] = 32'b0100000_00010_00001_100_00011_1111111; // add x3, x1, x2
        mem[0] = 32'b0000000_00010_00001_010_00011_0100011; // sw x2, 3(x1)
       // mem[8] = 32'b000000000110_00001_000_00100_0010011; // addi x4, x1, 6
        //mem[8] = 32'b0000000_00010_00001_000_00101_0110011; // add x5, x1, x2
	
end

always @(posedge clk)
begin
	$display("mem[4] : %d",mem[4]);
end


endmodule
