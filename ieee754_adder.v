module ieee754_adder(
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
    wire [23:0] mant_a = {1'b1, a[22:0]}; // Add implicit 1 for normalized
    wire [23:0] mant_b = {1'b1, b[22:0]}; // Add implicit 1 for normalized

    // Special case flags
    wire a_is_nan = (exp_a == 8'b11111111) && (a[22:0] != 0);
    wire b_is_nan = (exp_b == 8'b11111111) && (b[22:0] != 0);
    wire a_is_inf = (exp_a == 8'b11111111) && (a[22:0] == 0);
    wire b_is_inf = (exp_b == 8'b11111111) && (b[22:0] == 0);
    wire a_is_zero = (a[30:0] == 0);
    wire b_is_zero = (b[30:0] == 0);

    // Align exponents and perform addition
    reg [23:0] mant_res;
    reg [7:0] exp_res;
    reg sign_res;

    always @(*) begin
        if (a_is_nan || b_is_nan) begin
            // NaN propagation
            sign_res = 1'b0;
            exp_res = 8'b11111111;
            mant_res = 24'b10000000000000000000000; // Standard NaN representation
        end else if (a_is_inf || b_is_inf) begin
            if (a_is_inf && b_is_inf && (sign_a != sign_b)) begin
                // Inf - Inf = NaN
                sign_res = 1'b0;
                exp_res = 8'b11111111;
                mant_res = 24'b10000000000000000000000; // Standard NaN representation
            end else begin
                // Inf propagation
                sign_res = a_is_inf ? sign_a : sign_b;
                exp_res = 8'b11111111;
                mant_res = 24'b0;
            end
        end else if (a_is_zero || b_is_zero) begin
            // Zero propagation
            if (a_is_zero) begin
                sign_res = sign_b;
                exp_res = exp_b;
                mant_res = mant_b[23:0];
            end else begin
                sign_res = sign_a;
                exp_res = exp_a;
                mant_res = mant_a[23:0];
            end
        end else begin
            // Regular addition
            if (exp_a > exp_b) begin
                mant_res = mant_a + (mant_b >> (exp_a - exp_b));
                exp_res = exp_a;
                sign_res = sign_a;
            end else begin
                mant_res = (mant_a >> (exp_b - exp_a)) + mant_b;
                exp_res = exp_b;
                sign_res = sign_b;
            end

            // Normalize result
            if (mant_res[23]) begin
                mant_res = mant_res >> 1;
                exp_res = exp_res + 1;
            end
        end
    end

    // Pack result
    assign result = {sign_res, exp_res, mant_res[22:0]};

    // Overflow and underflow detection
    assign overflow = (exp_res == 8'b11111111);
    assign underflow = (exp_res == 8'b00000000);

endmodule

