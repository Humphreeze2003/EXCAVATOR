// THIS MODULE PARSES THE MACHINE CODE FETCHED FROM THE INSTRUCTIONS ROM , AND PARSES THE RESPECTIVE FIELDS TO THE RESPECTIVE BUFFERS

module CENTRAL_CONTROL_UNIT (
    input wire[31:0] instruction,




    output wire[6:0] op_code,
    output reg[3:0] op_type, 
    output reg[4:0] rd,
    output reg[4:0] rs1,
    output reg[4:0] rs2,
    output reg[31:0] immediate_value,
    output reg[9:0] funct_bits


    // output reg[31:0] current_instruction,   // comes from the program counter
    // output reg[31:0] next_instruction   // goes to the program counter
   
    
    
);

localparam[3:0]     R_TYPE = 4'b0001 ,
                    I_TYPE = 4'b0010 , 
                    J_TYPE = 4'b0011 , 
                    B_TYPE = 4'b0100 ,  
                    U_TYPE = 4'b0101 , 
                    S_TYPE = 4'b0110 ;
//                    B_TYPE = 4'b0111 ;


wire is_R;
wire is_I;
wire is_J;
wire is_B;
wire is_U;
wire is_S;

assign is_R = (instruction[6:0] == 7'b0110011);
assign is_I = (instruction[6:0] == 7'b0010011 || instruction[6:0] == 7'b0000011 || instruction[6:0] == 7'b1100111 || instruction[6:0] == 7'b01110011 || instruction[6:0] == 7'b0001111);
assign is_S = (instruction[6:0] == 7'b0100011);
assign is_U = (instruction[6:0] == 7'b0110111 || instruction[6:0] == 7'b0010111);
assign is_B = (instruction[6:0] == 7'b1100011);
assign is_J = (instruction[6:0] == 7'b1101111);



assign op_code = instruction[6:0];



always @(*) begin
    op_type = 4'b0;
    rd = 5'b0;
    rs1 = 5'b0;
    rs2 = 5'b0;
    funct_bits = 10'b0;
    immediate_value = 32'b0;

     if(is_R)begin
        op_type = R_TYPE;
        rd = instruction[11:7];
        funct_bits[2:0] = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct_bits[9:3] = instruction[31:25];
     end else if(is_I)begin
         op_type = I_TYPE;
        rd = instruction[11:7];
        funct_bits[2:0] = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct_bits[9:3] = instruction[31:25];
        immediate_value = { {20{instruction[31]}} , instruction[31:20]};

     end else if (is_J) begin
         op_type = J_TYPE;
         rd = instruction[11:7];
         immediate_value = {{11{instruction[31]}} , instruction[31] , instruction[19:12] , instruction[20] , instruction[30:21] , 1'b0   };  // no funct bits needed
    
     end else if (is_S) begin
         op_type = S_TYPE;
        immediate_value = {{20{instruction[31]}} , instruction[31:25] , instruction[11:7]  };
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct_bits[2:0] = instruction[14:12];  // only funct 3 is used (instruction[2:0])
     end else if(is_U)begin
                 op_type = U_TYPE;
                 rd = instruction[11:7];
                 immediate_value = {instruction[31:12] , {12{1'b0}}};
     end else if(is_B)begin
         op_type = B_TYPE;
        funct_bits[2:0] = instruction[14:12];  // only funct 3 is used
        immediate_value = {{19{instruction[31]}} , instruction[31] , instruction[7] , instruction[30:25] , instruction[11:8] , 1'b0};
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
     end
end
    
endmodule