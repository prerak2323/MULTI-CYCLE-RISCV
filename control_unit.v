module control_unit(
    input [31:0] IN,
    input zero,
    input clk,
    input rst,
    output reg write_reg,
    output reg write_mem,
    output reg addr_src,
    output reg irwrite,
    output reg alusrcA,
    output reg [1:0] alusrcB,
    output reg [3:0] op,
    output reg alu_mem,
    output reg pc_write,
    output reg [1:0] imm_type
);

// State and type definitions
reg [2:0] state;
reg [1:0] type;
parameter FETCH = 3'b000, DECODE = 3'b001, ALU_WB = 3'b010, MEM_FETCH = 3'b011,
           REG_WB = 3'b100, MEM_WB = 3'b101, BRANCH = 3'b110, pc_update=3'b111;
parameter R_TYPE = 2'b00, I_TYPE = 2'b01, S_TYPE = 2'b10, B_TYPE = 2'b11;

// Resettable state machine
always @(posedge clk or rst) begin
    if (rst) begin
                irwrite <= 1'b0;
                pc_write <= 1'b0;
                state<=FETCH;
    end else begin
        case (state)
            FETCH: begin
                write_reg <= 1'b0;
                write_mem <= 1'b0;
                addr_src <= 1'b0;
                irwrite <= 1'b1;
                pc_write<=1'b0;
                state <= DECODE;
            end
            
            DECODE: begin
                irwrite <= 1'b0;
                pc_write <= 1'b0;
                case (IN[6:0])
                    7'b0110011: begin
                        type <= R_TYPE;
                        state <= ALU_WB;
                    end
                    7'b0010011: begin
                      //  imm_type <= 2'b00;
                        type <= I_TYPE;
                        state <= ALU_WB;
                    end
                    7'b0000011: begin // Load (LW)
                       // imm_type <= 2'b00;
                        type <= I_TYPE;
                        state <= MEM_FETCH;
                    end
                    7'b0100011: begin
       
                        type <= S_TYPE;
                        state <= MEM_WB;
                    end
                    7'b1100011: begin
                       
                        type <= B_TYPE;
                        state <= BRANCH;
                    end
                  // 7'b1111111:  begin
                    //    type <= R_TYPE;
                      //  state <= ALU_WB;
                    //end
                    
                    default : irwrite <= 1'b0;
                endcase
            end           
            
            ALU_WB: begin
                
                alu_mem <= 1'b0;
                write_reg <= 1'b1;
              //  irwrite <= 1'b0;
                state <= pc_update;
            end
            MEM_FETCH: begin
                alu_mem <= 1'b0;
                addr_src <= 1'b1;
                state <= REG_WB;
            end
            REG_WB: begin
                alu_mem <= 1'b1;
                write_reg <= 1'b1;
                state <= pc_update;
            end
            MEM_WB: begin
                irwrite<=1'b0;
                alusrcA <= 1'b1;
                addr_src <= 1'b1;
                write_mem <= 1'b1;
                alu_mem <= 1'b0;
                state <= pc_update;
            end
            BRANCH: begin
                if (zero) begin
                    alusrcB <= 2'b00;
                    alu_mem <= 1'b0;
                    pc_write <= 1'b1;
                end
                else
                	pc_write <=1'b0;
                state <= FETCH;
            end
            
                
            pc_update : begin
            	   irwrite <= 1'b0;
            	   alusrcA <= 1'b0;
                   alusrcB <= 2'b10;
                   op <= 4'b0000;
                   pc_write <= 1'b1;
                   alu_mem <= 1'b0;
                   //addr_src <= 1'b0;
                   state <= FETCH;
            	    end
            default : state<=FETCH;
        endcase
    end
end

// Combinational logic for ALU control
always @(*) begin
    case (type)
        R_TYPE: begin
            alusrcA = 1'b1;
            alusrcB = 2'b00;
            case ({IN[14:12], IN[31], IN[30]})
                5'b00000: op = 4'b0000; // ADD 0
                5'b00001: op = 4'b0001; // SUB 1
                5'b00100: op = 4'b0010; // SLL 4
                5'b01000: op = 4'b1000; // SLT 8
                5'b10000: op = 4'b0110; // XOR 16
                5'b10100: op = 4'b0011; // SRL 20
                5'b10101: op = 4'b0111; // SRA 21
                5'b11000: op = 4'b0101; // OR 24
                5'b11100: op = 4'b0100; // AND 28
                5'b00010: op = 4'b1010; // add
                5'b00101: op = 4'b1011; // sub
                5'b00110: op = 4'b1100; //mul
                default: op = 4'b0000;
            endcase
        end
        I_TYPE: begin
            alusrcA = 1'b1;
            alusrcB = 2'b01;
            imm_type = 2'b00;
            case ({IN[6:0], IN[14:12]})
                10'b0010011000: op = 4'b0000; // ADDI
                10'b0010011010: op = 4'b1000; // SLTI
                10'b0010011100: op = 4'b0110; // XORI
                10'b0010011110: op = 4'b0101; // ORI
                10'b0010011111: op = 4'b0000; // ANDI
                10'b0010011001: op = 4'b0010; // SLLI
                10'b0010011101: op = 4'b0011; // SRLI
                10'b0000011010: op = 4'b0000; // LW Address Addition
                
            endcase
        end
        S_TYPE: begin
            alusrcA = 1'b1;
            alusrcB = 2'b01;
            op = 4'b0000;
            imm_type = 2'b01;
            addr_src <= 1'b1;
            alu_mem <= 1'b0;
            write_mem <= 1'b1;
            
        end
        B_TYPE: begin
            alusrcA = 1'b1;
            alusrcB = 2'b00;
            op = 4'b1001;
            imm_type = 2'b10;
        end
    endcase
end
endmodule
