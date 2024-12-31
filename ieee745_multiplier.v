module ieee745_multiplier(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result,
    output overflow,
    output underflow
);
    // Extract components
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] mant_a = {1'b1, a[22:0]}; // Implicit 1
    wire [23:0] mant_b = {1'b1, b[22:0]}; // Implicit 1

    // Special case flags
    wire a_is_nan = (exp_a == 8'b11111111) && (a[22:0] != 0);
    wire b_is_nan = (exp_b == 8'b11111111) && (b[22:0] != 0);
    wire a_is_inf = (exp_a == 8'b11111111) && (a[22:0] == 0);
    wire b_is_inf = (exp_b == 8'b11111111) && (b[22:0] == 0);
    wire a_is_zero = (a[30:0] == 0);
    wire b_is_zero = (b[30:0] == 0);

    // Multiply mantissas and add exponents
    wire [47:0] mant_product = mant_a * mant_b;
    wire [8:0] exp_sum = exp_a + exp_b - 127; // Remove bias from exponent addition
    wire sign_res = sign_a ^ sign_b; // Result sign is XOR of inputs' signs

    // Normalize result
    reg [7:0] exp_res;
    reg [23:0] mant_res;
    always @(*) begin
        if (mant_product[47]) begin
            // MSB is set
            mant_res = mant_product[46:23];
            exp_res = exp_sum + 1;
        end else begin
            // Normalize result
            mant_res = mant_product[45:22];
            exp_res = exp_sum;
        end
    end

    // Handle special cases
    always @(*) begin
        if (a_is_nan || b_is_nan) begin
            exp_res = 8'b11111111;
            mant_res = 24'b10000000000000000000000; // NaN
        end else if (a_is_inf || b_is_inf) begin
            if (a_is_zero || b_is_zero) begin
                exp_res = 8'b11111111;
                mant_res = 24'b10000000000000000000000; // NaN
            end else begin
                exp_res = 8'b11111111;
                mant_res = 0; // Infinity
            end
        end else if (a_is_zero || b_is_zero) begin
            exp_res = 0;
            mant_res = 0; // Zero
        end
    end

    // Pack result
    assign result = {sign_res, exp_res, mant_res[22:0]};
    assign overflow = (exp_res == 8'b11111111);
    assign underflow = (exp_res == 8'b00000000);

endmodule

