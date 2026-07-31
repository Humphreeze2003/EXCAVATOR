module command_parser (
    input clk,
    input rst,

    // input wire[31:0] data_in, // fro SPI
    // input wire[31:0] offset,
    // input write_en,
    // input enable,

     input wire[31:0] data_from_system_mode_reg,
     input wire[31:0] data_from_control_reg,
     input wire[31:0] data_from_SPI,


    output reg[31:0] data_out
);

reg[31:0] packet;
reg[7:0] command;
reg[7:0] command_parameter;
reg[7:0] action;

 

    
endmodule