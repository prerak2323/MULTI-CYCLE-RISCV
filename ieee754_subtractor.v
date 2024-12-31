module ieee754_subtractor(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result,
    output overflow,
    output underflow
);
    wire [31:0] b_neg; // Negate `b` for subtraction
    assign b_neg = {~b[31], b[30:0]}; // Flip sign bit of `b`

    ieee754_adder adder (
        .a(a),
        .b(b_neg),
        .result(result),
        .overflow(overflow),
        .underflow(underflow)
    );
endmodule

