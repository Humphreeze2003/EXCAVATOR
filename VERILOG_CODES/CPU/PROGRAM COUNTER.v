module PROGRAM_COUNTER(
    input clk,
    input rst,
    
    input wire[31:0] next_address,  // updated address after the instruction is fetched
    output reg [31:0] current_address_to_mem  // address of the next instruction to be executed
    output reg [31:0] current_address_to_op_dec  // address of the next instruction to be executed

 );


always @(posedge clk or negedge rst) begin
      if(!rst)begin
        current_address <= 32'd1130;
        
      end else begin
          current_address <= next_address;
      end
end

endmodule






