module alu(a, b, op, result, zero, overflow, underflow);
input [31:0]a, b;
output reg [31:0]result;
input [3:0]op;
output reg  overflow, underflow;
output zero;
    wire [31:0] add_result, sub_result, mul_result;
    wire add_overflow, sub_overflow, mul_overflow;
    wire add_underflow, sub_underflow, mul_underflow;

    // Instantiate modules
    ieee754_adder add_module(
        .a(a),
        .b(b),
        .result(add_result),
        .overflow(add_overflow),
        .underflow(add_underflow)
    );

    ieee754_subtractor sub_module(
        .a(a),
        .b(b),
        .result(sub_result),
        .overflow(sub_overflow),
        .underflow(sub_underflow)
    );

    ieee745_multiplier mul_module(
        .a(a),
        .b(b),
        .result(mul_result),
        .overflow(mul_overflow),
        .underflow(mul_underflow)
    );



always @(*)
begin
	case(op)
		4'b0000 : result = a + b;
		4'b0001 : result = a + ((~b) + 1);
		4'b0010 : result = a << b;
		4'b0011 : result = a >> b;
		4'b0100 : result = a & b;
		4'b0101 : result = a | b;
		4'b0110 : result = a ^ b;
		4'b0111 : result = a >>> b;
		4'b1000 : if(a<b)
				result = 32'd1;
			  else
			  	result = 32'd0;
		4'b1001 : if(a==b)
				result = b;
			  else
			  	result = 32'b0;
		4'b1010 : begin
		          result = add_result;
		          overflow = add_overflow;
		          underflow = add_underflow;
			  end
		4'b1011 : begin
		          result = sub_result;
		          overflow = sub_overflow;
		          underflow = sub_underflow;
			  end
		4'b1100 : begin
		          result = mul_result;
		          overflow = mul_overflow;
		          underflow = mul_underflow;
			  end  
		//default : 4'bxxxx;
	endcase
		
end




assign zero = (result) ? 1'b1 : 1'b0;


endmodule
