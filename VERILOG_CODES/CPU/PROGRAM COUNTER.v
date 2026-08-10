module PROGRAM_COUNTER(
    input clk,
    input rst,
    
    input wire[31:0] next_address,  // updated address after the instruction is fetched
    output reg [31:0] current_address_to_mem,  // address of the next instruction to be executed
    output reg [31:0] current_address_to_op_dec  // address of the next instruction to be executed
//     output reg[15:0]  cpu_address_bus_mux_signal 

 );


always @(posedge clk or negedge rst) begin
      if(!rst)begin
        current_address_to_mem <= 32'd1130;
        current_address_to_op_dec <= 32'd1130;
//        cpu_address_bus_mux_signal <= 16'b0;
        
      end else begin
          current_address_to_mem <= next_address;
          current_address_to_op_dec <= next_address;
//          cpu_address_bus_mux_signal <= 16'b1;
          
      end
end



endmodule






