module MEM_TO_CPU_DATA_MUX(

input wire[31:0] data_from_i_rom,
input wire[31:0] data_from_ram,
input wire[31:0] data_from_rodata,
input wire[31:0] data_from_dc_motor,
input wire[31:0] data_from_stepper,
input wire[31:0] data_from_servo,
input wire[31:0] data_from_nrf,
input wire[31:0] data_from_spi,
input wire[31:0] data_from_syst_regs,




input wire[15:0] control_signal, 


output reg[31:0] data_to_cpu




);



always @(*)begin

data_to_cpu = 32'b0;

case(control_signal)


16'd0: data_to_cpu = 32'b0;
16'd1: data_to_cpu = data_from_i_rom;
16'd2: data_to_cpu = data_from_ram;
16'd3: data_to_cpu = data_from_rodata;
16'd4: data_to_cpu = data_from_dc_motor;
16'd5: data_to_cpu = data_from_stepper;
16'd6: data_to_cpu = data_from_servo;
16'd7: data_to_cpu = data_from_nrf;
16'd8: data_to_cpu = data_from_spi;
16'd9: data_to_cpu = data_from_syst_regs;
//16'd0: data_to_cpu = 32'b0;

endcase








end









endmodule