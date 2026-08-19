module RAM(
    input clk,
    input rst,


    input wire[31:0] offset,
    output [31:0] data_to_cpu,
    input wire[31:0] data_from_cpu,
    input enable,
    input write_en
);



reg[31:0] RAM [0:255];



assign data_to_cpu = (enable && !write_en)?RAM[offset]:32'b0;

always @(posedge clk or negedge rst) begin
    if(!rst)begin
        
    end else begin
        if(write_en)begin
            RAM[offset] <= data_from_cpu;
        end
    end
end

endmodule