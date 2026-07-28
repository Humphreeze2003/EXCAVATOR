module OP_DECODER (
    input wire[6:0] op_code,
    input wire[3:0] op_type,
    input wire[9:0] funct_bits,
    input wire[31:0] current_instruction_address,  // address of the current instruction


    input wire[31:0] rs1,
    input wire[31:0] rs2,
    input wire[31:0] rd,
    input wire[31:0] immediate_value

    
    output reg[31:0] next_address,  // address of the next instruction
    output reg[9:0] alu_operation,

    // output reg[4:0] rs1_address,  // adress to read from
    // output reg[4:0] rs2_address, // address to read from
    // output reg[4:0] rd_address,  // adress to write to

    // output reg read_en,   // not needed
    output reg cpu_write_en,
    output reg mem_write_enable,

     output reg[7:0] mux_control_signal
);
    
    localparam[3:0]     R_TYPE = 4'b0001 ,
                        I_TYPE = 4'b0010 , 
                        J_TYPE = 4'b0011 , 
                        B_YTPE = 4'b0100 ,  
                        U_TYPE = 4'b0101 , 
                        S_TYPE = 4'b0110 ,
                        B_TYPE = 4'b0111 ;


//    localparam[7:0]  ADD = 8'd1 , 
//                     SUB = 8'd2 , 
//                     OR =8'd3  , 
//                     XOR = 8'd4 , 
//                     AND = 8'd5 ,
//                     ADDI = 8'd6;



localparam [9:0]
    ADD   = 10'd1,
    SUB   = 10'd2,

    OR_OP = 10'd3,
    XOR_OP= 10'd4,
    AND_OP= 10'd5,

    ADDI  = 10'd6,
    ANDI  = 10'd7,
    ORI   = 10'd8,
    XORI  = 10'd9,

    SLL   = 10'd10,
    SLLI  = 10'd11,

    SRL   = 10'd12,
    SRLI  = 10'd13,

    SRA   = 10'd14,
    SRAI  = 10'd15,

    SLT   = 10'd16,
    SLTI  = 10'd17,

    SLTU  = 10'd18,
    SLTIU = 10'd19,

    JAL   = 10'd20,
    JALR  = 10'd21,

    BEQ   = 10'd22,
    BNE   = 10'd23,
    BLT   = 10'd24,
    BGE   = 10'd25,
    BLTU  = 10'd26,
    BGEU  = 10'd27,

    LUI   = 10'd28,
    AUIPC = 10'd29,

    LW    = 10'd30,
    SW    = 10'd31;






    always @(*) begin
    next_address = current_instruction_address;
    alu_operation = 8'b0;
    cpu_write_en = 0;
    mem_write_enable = 0;
    mux_control_signal = 0;

if(op_type == R_TYPE)begin

            // next_address = current_instruction_address + (31'd4 / 31'd1);  // for ths project , my adresses progress by 1 , not 4 for simplicity
            // if(funct_bits == 10'b0)begin
            //   alu_operation = ADD;
            // end else if(funct_bits == 10'b0100000000)begin
            //   alu_operation = SUB;
            // end

               next_address = current_instruction_address + 1;

    // read_en = 1;
    cpu_write_en = 1;

    case(funct_bits)

        10'b0000000000 : alu_operation = ADD;

        10'b0100000000 : alu_operation = SUB;

        10'b0000000111 : alu_operation = AND_OP;

        10'b0000000110 : alu_operation = OR_OP;

        10'b0000000100 : alu_operation = XOR_OP;

        10'b0000000001 : alu_operation = SLL;

        10'b0000000101 : alu_operation = SRL;

        10'b0100000101 : alu_operation = SRA;

        10'b0000000010 : alu_operation = SLT;

        10'b0000000011 : alu_operation = SLTU;

    endcase

end else if(op_type == I_TYPE)begin

        //    next_address = current_instruction_address + (31'd4 / 31'd1);  // for ths project , my adresses progress by 1 , not 4 for simplicity
        //     if(op_code == 7'b0010011)begin
        //        if(funct_bits[2:0] == 3'b000)begin
        //          alu_operation = ADDI;
        //        end
        //     end else  if(op_code == 7'b0000011)begin
              
        //     end else  if(op_code == 7'b1100111)begin
              
        //     end else  if(op_code == 7'b1110011)begin
              
        //     end else  if(op_code == 7'b0001111)begin
              
        //     end

         next_address = current_instruction_address + 1;

    if(op_code == 7'b0010011) begin

        // read_en = 1;
        cpu_write_en = 1;

        case(funct_bits)

            10'b0000000000 : alu_operation = ADDI;

            10'b0000000111 : alu_operation = ANDI;

            10'b0000000110 : alu_operation = ORI;

            10'b0000000100 : alu_operation = XORI;

            10'b0000000001 : alu_operation = SLLI;

            10'b0000000101 : alu_operation = SRLI;

            10'b0100000101 : alu_operation = SRAI;

            10'b0000000010 : alu_operation = SLTI;

            10'b0000000011 : alu_operation = SLTIU;

        endcase

    end else if(op_code == 7'b0000011) begin  // LOADS

        // read_en = 1;
       

        case(funct_bits[2:0])

            3'b010 :begin
            alu_operation = LW;
            cpu_write_en = 1;  // we write to CPU
            end 
            
        endcase

    end      else if(op_code == 7'b1100111) begin

        // read_en = 1;
        cpu_write_en = 1;

        alu_operation = JALR;

        next_address = rs1 + immediate_value;

    end
         



end else if(op_type == J_TYPE)begin

                    // read_en = 0;
                    cpu_write_en = 1;

                    alu_operation = JAL;

                    next_address = current_instruction_address + immediate_value;

end else if(op_type == B_TYPE)begin

            // read_en = 1;
    cpu_write_en = 0;

    case(funct_bits[2:0])

        3'b000:
        begin
            alu_operation = BEQ;

            if(rs1_value == rs2_value)
                next_address = current_instruction_address + immediate_value;
            else
                next_address = current_instruction_address + 1;
        end

        3'b001:
        begin
            alu_operation = BNE;

            if(rs1_value != rs2_value)
                next_address = current_instruction_address + immediate_value;
            else
                next_address = current_instruction_address + 1;
        end

        3'b100:
        begin
            alu_operation = BLT;

            if($signed(rs1_value) < $signed(rs2_value))
                next_address = current_instruction_address + immediate_value;
            else
                next_address = current_instruction_address + 1;
        end

        3'b101:
        begin
            alu_operation = BGE;

            if($signed(rs1_value) >= $signed(rs2_value))
                next_address = current_instruction_address + immediate_value;
            else
                next_address = current_instruction_address + 1;
        end

    endcase

           
end  else if(op_type == U_TYPE)begin

         next_address = current_instruction_address + 1;

            cpu_write_en = 1;
            // read_en = 0;

            case(op_code)

                7'b0110111 :
                    alu_operation = LUI;

                7'b0010111 :
                    alu_operation = AUIPC;

            endcase
           
end else if (op_type == S_TYPE)begin
                                next_address = current_instruction_address + 1;

                    // read_en = 1;
                   

                    case(funct_bits[2:0])

                        3'b010 :
                            //  cpu_write_en = 0;
                            mem_write_enable = 0;
                            alu_operation = SW;

                    endcase
         end
    end
endmodule