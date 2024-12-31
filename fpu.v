module fpu(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op, // 00: add, 01: subtract, 10: multiply, 11: divide
    output [31:0] result,
    output overflow,
    output underflow
);
    wire [31:0] add_result, sub_result, mul_result, div_result;
    wire add_overflow, sub_overflow, mul_overflow, div_overflow;
    wire add_underflow, sub_underflow, mul_underflow, div_underflow;

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

    ieee754_divider div_module(
        .a(a),
        .b(b),
        .result(div_result),
        .overflow(div_overflow),
        .underflow(div_underflow)
    );

    // Select result based on operation
    assign result = (op == 2'b00) ? add_result :
                    (op == 2'b01) ? sub_result :
                    (op == 2'b10) ? mul_result :
                    div_result;

    // Select overflow and underflow
    assign overflow = (op == 2'b00) ? add_overflow :
                      (op == 2'b01) ? sub_overflow :
                      (op == 2'b10) ? mul_overflow :
                      div_overflow;

    assign underflow = (op == 2'b00) ? add_underflow :
                       (op == 2'b01) ? sub_underflow :
                       (op == 2'b10) ? mul_underflow :
                       div_underflow;
endmodule
