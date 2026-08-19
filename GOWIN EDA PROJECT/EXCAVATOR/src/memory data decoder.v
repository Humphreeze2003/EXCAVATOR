module MEM_DATA_DEMULTIPLEXER(
input wire[15:0] control_signal,

input wire[31:0] data,  // from memory 
output reg[31:0] to_ccu,
output reg[31:0] to_write_back_mux

);


always @(*)begin

to_ccu = 32'b0;
to_write_back_mux = 32'b0;

case(control_signal)

16'b0: begin  // nothing
to_ccu = 32'b0;
to_write_back_mux = 32'b0;

end


16'd1: begin  // to ccu
to_ccu = data;
//to_ccu = 32'b0;

end



16'd2: begin // to write_back_mux
to_write_back_mux = data;
//to_ccu = 32'b0;

end








endcase






end




















endmodule