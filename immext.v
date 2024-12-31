module immext(imm, ext, f, clk);

input [31:0]imm;
output reg [31:0]ext;
input [1:0]f;
input clk;

always @(posedge clk) begin
    case (f)
        2'b00: ext = {{20{imm[31]}}, imm[31:20]};                      // I-type
        2'b01: ext = {{20{imm[31]}}, imm[31:25], imm[11:7]};          // S-type
        2'b10: ext = {{20{imm[31]}}, imm[7], imm[30:25], imm[11:8], 1'b0}; // B-type
    endcase
end

endmodule

