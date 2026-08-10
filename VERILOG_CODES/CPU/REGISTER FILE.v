module CPU_REGS (
    input clk,
    input rst,

    input wire[4:0] rs1,  // address
    input wire[4:0] rs2, // address
     input wire[4:0] destination_reg, // address

    input write_enabled,  
    input wire[31:0] write_data,
   

    output wire[31:0] read_data1,
    output wire[31:0] read_data2

    

); 
integer i;

reg[31:0] CPU_REGISTERS [0:31];




// reads are asynchronous wile rites are synchronous
    assign read_data1 = (rs1 == 5'd0)?32'b0 : CPU_REGISTERS[rs1];
    assign read_data2 = (rs2 == 5'd0)?32'd0 : CPU_REGISTERS[rs2];

    always @(posedge clk or negedge rst) begin
        if(!rst)begin 
       for(i = 0; i <= 31; i = i + 1)begin 
       CPU_REGISTERS[i] <= 32'b0;
end
  end   else begin 
     if(write_enabled && destination_reg != 0)begin
            CPU_REGISTERS[destination_reg] <= write_data;
        end
 end
        
    end
endmodule