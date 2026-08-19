module SYSTEM_REGS(
    input clk,
    input rst,


    input wire[31:0] data_from_cpu,
    output wire[31:0] data_to_cpu,
    input enable,
    input write_en,
    input wire[31:0] offset

    // output wire[31:0] data_out
);


reg[31:0] system_mode_reg;
reg[31:0] system_reset_reg;


assign data_to_cpu = (enable && !write_en && offset == 0)?system_mode_reg:(enable && !write_en && offset == 1)?system_reset_reg:32'b0;

always @(posedge clk or negedge rst) begin
    if(!rst)begin
      system_reset_reg <= 32'b1;  
    end else begin
        if(enable && write_en)begin
            case (offset)
                0: system_mode_reg <= data_from_cpu;
                1: system_reset_reg <= data_from_cpu;
                default: ;
            endcase
        end
    end
end
endmodule