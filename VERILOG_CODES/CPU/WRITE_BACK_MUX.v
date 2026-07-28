module WRITE_BACK_MUX(
    input wire[7:0] control_signal,
    input wire[31:0] from_alu,
    input wire[31:0] from_mem, 
    input wire[31:0] address_plus_1, 

    output reg[31:0] mux_out
);




always @(*) begin
     mux_out = 32'b0;

     case (control_signal)
        8'd0:mux_out = from_alu;
        8'd1:mux_out = from_mem;
        8'd2:mux_out = address_plus_1
        default: 
     endcase
end

endmodule