module ALU (
    
    input[31:0] rs1,
    input[31:0] rs2,
    input[31:0] immediate,
    input[9:0] operation,

    output reg[31:0] result,

    // flags
    // output  reg branch_taken  // for when a branch is taken
);


  //  localparam[7:0]  ADD = 8'd1 , 
  //                   SUB = 8'd2 , 
  //                   OR =8'd3  , 
  //                   XOP = 8'd4 , 
  //                   AND = 8'd5 ,
  //                   ADDI = 8'd6;



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
      // branch_taken = 0;
      result = 0;
        result = 32'b0;
    //     if(operation == ADD)begin
    //       result = rs1 + rs2;
    //     end else if(operation == SUB)begin
    //       result = rs1 - rs2;
    //     end else if(operation == ADDI)begin
    //       result = rs1 + immediate;
    //     end




    always @(*) begin

    result = 32'd0;

    case(operation)

    //-------------------------
    // Arithmetic
    //-------------------------

    ADD  : result = rs1 + rs2;

    SUB  : result = rs1 - rs2;

    ADDI : result = rs1 + immediate;

    //-------------------------
    // Logical
    //-------------------------

    AND_OP : result = rs1 & rs2;

    ANDI   : result = rs1 & immediate;

    OR_OP  : result = rs1 | rs2;

    ORI    : result = rs1 | immediate;

    XOR_OP : result = rs1 ^ rs2;

    XORI   : result = rs1 ^ immediate;

    //-------------------------
    // Shift
    //-------------------------

    SLL  : result = rs1 << rs2[4:0];

    SLLI : result = rs1 << immediate[4:0];

    SRL  : result = rs1 >> rs2[4:0];

    SRLI : result = rs1 >> immediate[4:0];

    SRA  : result = $signed(rs1) >>> rs2[4:0];

    SRAI : result = $signed(rs1) >>> immediate[4:0];

    //-------------------------
    // Set Less Than
    //-------------------------

    SLT : result = ($signed(rs1) < $signed(rs2)) ? 32'd1 : 32'd0;

    SLTI : result = ($signed(rs1) < $signed(immediate)) ? 32'd1 : 32'd0;

    SLTU : result = (rs1 < rs2) ? 32'd1 : 32'd0;

    SLTIU : result = (rs1 < immediate) ? 32'd1 : 32'd0;

    //-------------------------
    // Address Generation
    //-------------------------

    // Load Word
    LW : result = rs1 + immediate;

    // Store Word
    SW : result = rs1 + immediate;

    //-------------------------
    // Upper Immediate
    //-------------------------

    LUI : result = immediate;

    AUIPC : result = immediate;
        // Normally PC + immediate is computed outside the ALU
        // or by giving the ALU the PC as an operand.

    //-------------------------
    // Branch Comparisons
    //-------------------------

    BEQ : result = (rs1 == rs2);

    BNE : result = (rs1 != rs2);

    BLT : result = ($signed(rs1) < $signed(rs2));

    BGE : result = ($signed(rs1) >= $signed(rs2));

    BLTU : result = (rs1 < rs2);

    BGEU : result = (rs1 >= rs2);

    //-------------------------
    // Jump Instructions
    //-------------------------

    JAL : result = 32'd0;
        // write-back (PC+1) comes from PC logic

    JALR : result = rs1 + immediate;
        // target address before clearing bit 0

    default : result = 32'd0;

    endcase

end


    end

endmodule