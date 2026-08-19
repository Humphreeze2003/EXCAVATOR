module CPU_ADDRESS_BUS_MUX(
 input wire[15:0] control_signal,
 
  input wire[31:0] pc_val , // address from pc_couneter
  input wire[31:0] alu_val , // address from alu


  output reg[31:0] mux_out

);



always @(*) begin 

mux_out = 32'b0;
case(control_signal)


 16'd0:  mux_out = 32'd0;
 16'd1: mux_out = pc_val;
 16'd2: mux_out = alu_val;






endcase






end














endmodule