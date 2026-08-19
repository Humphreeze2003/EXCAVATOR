//module RODATA(
//    input clk,
//    input rst,


//    
//    input wire[31:0] data_from_cpu,
//    output wire[31:0] data_to_cpu,
//    input wire[31:0] offset,
//    input  write_en, // not needed since ROM is read only
//    input  enable


//);



//reg[31:0] RODATA_ROM[0:255];

//initial begin
//    RODATA_ROM[0] = 32'd0;             //  RAM BASE ADDRESS
//    RODATA_ROM[1] = 32'd256;           //  i_ROM BASE ADDRESS
//    RODATA_ROM[2] = 32'd2303;          //  rodata BASE ADDRESS
//    RODATA_ROM[3] = 32'd2559;          //  bss base address
//    RODATA_ROM[4] = 32'd2815;          //  data base address
//    RODATA_ROM[5] = 32'd3071;           //  mem mapped i/o/periperals base address
//    RODATA_ROM[6] = 32'd3071;          //  dc motor peripheral base address 
//    RODATA_ROM[7] = 32'd3103;          //  ex base stepper motor peripheral base address
//    RODATA_ROM[8] = 32'd3135;          //  steer servo motor peripheral base address
//    RODATA_ROM[9] = 32'd3167;          //  SPI peripheral base address
//    RODATA_ROM[10] = 32'd3199;         //  NRF peripheral base address
//    RODATA_ROM[11] = 32'd255;          //  RAM base address
//    RODATA_ROM[12] = 32'd3231;         //  SYSTEM REGS base address
//    
//end

//   
// assign data_to_cpu = (enable)?RODATA_ROM[offset]:32'd0;   // reads are asynchronous



//endmodule