module MEMORY(
    input clk,
    input rst,

    // cpu interface
    output wire[31:0] data_to_cpu,
    input wire[31:0] data_from_cpu,
    input wire[31:0] address_bus,

    input write_en,





  // PERIPHERAL OUTPUTS / inputs
    
    // dc outputs / inputs
output wire sig_a,
output wire sig_b,
output wire sig_c,
output wire sig_d,


// stepper outputs / inputs

output wire stepper_step_signal,
output wire stepper_direction_signal,

// servo outputs / inputs
output wire servo_pulse,


// spi outputs / inputs
output wire MOSI,
input wire MISO,
output wire SPI_CLK,
output wire slave_select,


  // NRF outputs / inputs
    input NRF_IRQ,


output wire[15:0] mem_data_demux_control_signal,



output wire[31:0] debug_enable_irom,
output wire[31:0] debug_enable_ram,
output wire[31:0] debug_offset
//output wire[31:0] debug_mux_sig

);


  //address decoder wires
  wire enable_rodata;
  wire enable_irom;
 assign debug_enable_irom = enable_irom;
  wire enable_ram;
assign debug_enable_ram = enable_ram;
  wire enable_dc_motor;
  wire enable_stepper_motor;
  wire enable_servo_motor;
  wire enable_nrf;
  wire enable_spi;
  wire enable_sys_regs;
  wire[31:0] offset;
assign debug_offset = offset;
  wire[15:0] mux_sig;

ADDRESS_DECODER dec(
      .clk(clk),
      .rst(rst),

      .address_bus(address_bus),
      .enable_rodata(enable_rodata),
      .enable_instruction_rom(enable_irom),
      .enable_RAM(enable_ram),
      .enable_driver_dc_motor(enable_dc_motor),
      .enable_stepper_motor(enable_stepper_motor),
      .enable_servo_motor(enable_servo_motor),
      .enable_nrf(enable_nrf),
      .enable_spi(enable_spi),
      .enable_system_regs(enable_sys_regs),

      .offset(offset),
      .mem_to_cpu_data_mux_sig(mux_sig),
      .mem_data_demux_control_signal(mem_data_demux_control_signal)
);


// mem_to_cpu_data_mux wires

 wire[31:0] data_from_i_rom;
 wire[31:0] data_from_ram;
 wire[31:0] data_from_rodata;
 wire[31:0] data_from_dc_motor;
 wire[31:0] data_from_stepper;
 wire[31:0] data_from_servo;
 wire[31:0] data_from_nrf;
 wire[31:0] data_from_spi;
 wire[31:0] data_from_syst_regs;

MEM_TO_CPU_DATA_MUX mem_to_cpu_data_mux(

 .data_from_i_rom(data_from_i_rom),
 .data_from_ram(data_from_ram),
 .data_from_rodata(data_from_rodata),
 .data_from_dc_motor(data_from_dc_motor),
 .data_from_stepper(data_from_stepper),
 .data_from_servo(data_from_servo),
 .data_from_nrf(data_from_nrf),
 .data_from_spi(data_from_spi),
 .data_from_syst_regs(data_from_syst_regs),




 .control_signal(mux_sig),

 .data_to_cpu(data_to_cpu)

);




INSTRUCTION_ROM i_rom(
    .clk(clk),
    .rst(rst),
    .enable(enable_irom),
    .offset(offset),
    .instruction(data_from_i_rom)
);



RAM ram(
   .clk(clk),
   .rst(rst),


   .offset(offset),
   .data_to_cpu(data_from_ram),
   .data_from_cpu(data_from_cpu),
   .enable(enable_ram),
   .write_en(write_en)
    


);






//RODATA rodata(
//    .clk(clk),
//    .rst(rst),

//    .data_from_cpu(data_from_cpu),
//    .data_to_cpu(data_from_rodata),
//    .offset(offset),
//    .write_en(write_en),
//    .enable(enable_rodata)
//);




// // dc wires
// wire sig_a;
// wire sig_b;
// wire sig_c;
// wire sig_d;

DC_DRIVER_MOTOR dc(

     .clk(clk),
     .rst(rst),

    .data_from_cpu(data_from_cpu),
    .data_to_cpu(data_from_dc_motor),
    .offset(offset),
    .write_en(write_en),
    .enable(enable_dc_motor),


    // .system_mode_reg_bits(system_reg_bits), //=================will come from system regs peripheral

    .signal_A(sig_a),
    .signal_B(sig_b),
    .signal_C(sig_c),
    .signal_D(sig_d)
);




// // stepper wires

// wire stepper_step_signal;
// wire stepper_direction_signal;


EXCAVATOR_ARM_BASE_STEPPER_MOTOR ex_base_motor(
    .clk(clk),
    .rst(rst),


    .enable(enable_stepper_motor),
    // .system_mode_reg_bits(system_reg_bits), //=================will come from system regs peripheral
    .offset(offset),
    .data_from_cpu(data_from_cpu),
    .data_to_cpu(data_from_stepper),

    .write_en(write_en),
    .step(stepper_step_signal),
    .direction(stepper_direction_signal)
);



// // servo wires
// wire servo_pulse;

STEERING_STEPPER_MOTOR servo(
    .clk(clk),
    .rst(rst),

    .enable(enable_servo_motor),
    // .system_mode_reg_bits(system_reg_bits)  //=================will come from system regs peripheral
    .offset(offset),
    .data_from_cpu(data_from_cpu),
    .data_to_cpu(data_from_servo),
    .write_en(write_en),

    .pulse(servo_pulse)
);






NRF_RECEIVER nrf(
    .clk(clk),
    .rst(rst),
    .IRQ(NRF_IRQ),

    .data_from_cpu(data_from_cpu),
    .data_to_cpu(data_from_nrf),

    .write_en(write_en),
    .enable(enable_nrf),
    .offset(offset)
    

);


// // spi wires
// wire MOSI;
// wire MISO;
// wire SPI_CLK;
// wire slave_select;



SPI spi(
    .clk(clk),
    .rst(rst),

    .offset(offset),
    .write_en(write_en),
    .enable(enable_spi),

    .MOSI(MOSI),
    .MISO(MISO),
    .SPI_CLK(SPI_CLK),
    .slave_select(slave_select),

    .data_from_cpu(data_from_cpu),
//    .write_en(write_en),
    .data_to_cpu(data_from_spi)
//    .offset(offset)
);





SYSTEM_REGS sys_regs(
    .clk(clk),
    .rst(rst),

    .data_from_cpu(data_from_cpu),
    .data_to_cpu(data_from_syst_regs),
    .enable(enable_sys_regs),
    .write_en(write_en),
    .offset(offset)

    

);


endmodule