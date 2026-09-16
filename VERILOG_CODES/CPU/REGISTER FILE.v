module CPU_REGS (
    input clk,
    input rst,

    input wire[4:0] rs1,  // address
    input wire[4:0] rs2, // address
     input wire[4:0] destination_reg, // address

    input write_enabled,  
    input wire[31:0] write_data,
   

    output wire[31:0] read_data1,
    output wire[31:0] read_data2,

    output wire[31:0] reg_a0,
    output wire[31:0] reg_a1,
    output wire[31:0] reg_a2,
    output wire[31:0] reg_a3,
    output wire[31:0] reg_a4,
    output wire[31:0] reg_a5,
    output wire[31:0] reg_a6,
    output wire[31:0] reg_a7,
    output wire[31:0] reg_sp,
    output wire[31:0] reg_s0,
    output wire[31:0] reg_ra
); 
integer i;

reg[31:0] CPU_REGISTERS [0:31];


  assign reg_a0 = CPU_REGISTERS[10];
  assign reg_a1 = CPU_REGISTERS[11];
  assign reg_a2 = CPU_REGISTERS[12];
  assign reg_a3 = CPU_REGISTERS[13];
  assign reg_a4 = CPU_REGISTERS[14];
  assign reg_a5 = CPU_REGISTERS[15];
  assign reg_a6=  CPU_REGISTERS[16];
  assign reg_a7 = CPU_REGISTERS[17];
  assign reg_sp = CPU_REGISTERS[2];
  assign reg_s0 = CPU_REGISTERS[8];
  assign reg_ra = CPU_REGISTERS[1];
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

     $display(
                "REG_WRITE | time=%0t | rd=x%0d | data=0x%08h | WE=%b",
                $time,
                destination_reg,
                write_data,
                write_enabled
            );
        end
 end
        
    end
endmodule