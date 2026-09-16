module PROGRAM_COUNTER(
    input clk,
    input rst,
    input wire[31:0] cpu_fsm_state,
    input wire[31:0] execute_cycles_counter,
    input wire[31:0] next_address,  // updated address after the instruction is fetched
    output reg [31:0] current_address_to_mem,  // address of the next instruction to be executed
    output reg [31:0] current_address_to_op_dec  // address of the next instruction to be executed
//     output reg[15:0]  cpu_address_bus_mux_signal 

 );


localparam[31:0] FETCHING = 32'd0 , 
                 DECODE_EXECUTE = 32'd1;

always @(posedge clk or negedge rst) begin
      if(!rst)begin
        current_address_to_mem <= 32'd1130;  // 1130 - 256 = 874
        current_address_to_op_dec <= 32'd1130; // 1130 - 256 = 874
//        cpu_address_bus_mux_signal <= 16'b0;
        
      end else begin
          if(cpu_fsm_state == DECODE_EXECUTE && execute_cycles_counter == 32'd3)begin 
          current_address_to_mem <= next_address;
          current_address_to_op_dec <= next_address;
//          cpu_address_bus_mux_signal <= 16'b1;
             end else begin

    current_address_to_mem <= current_address_to_mem;
    current_address_to_op_dec <= current_address_to_op_dec;
          

end
          
      end
end



endmodule






