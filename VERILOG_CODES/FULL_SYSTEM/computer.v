module COMPUTER(
    input clk,
    input rst,

// debugging signals

output wire[31:0] debug__address_bus,
output wire[31:0] debug_mem_to_cpu,
output wire[31:0] debug_cpu_to_mem,
output wire[31:0] debug_write_enable,
output wire[31:0] debug_op_dec_next_address,
output wire[31:0] debug_alu_result,
output wire[31:0] debug_alu_address_out,

   output wire[31:0] debug_ccu_opcode,
   output wire[31:0] debug_ccu_optype,
   output wire[31:0] debug_ccu_rd,
   output wire[31:0] debug_ccu_rs1,
   output wire[31:0] debug_ccu_rs2,
   output wire[31:0] debug_ccu_imm,
   output wire[31:0] debug_ccu_funct_bits,
   output wire[31:0] debug_plus_1_out_bits,
   output wire[31:0] debug_instruction_register,
output wire[31:0] debug_enable_irom,
output wire[31:0] debug_enable_ram,
output wire[31:0] debug_offset,
output wire[31:0] debug_ipc_address_to_opdec,
output wire[31:0] debug_pc_address_to_mem,
output wire[15:0] debug_cpu_address_bus_mux_signal,
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
    input NRF_IRQ
);

// cpu wires
wire[31:0] cpu_to_mem;
assign debug_cpu_to_mem = cpu_to_mem;
wire[31:0] mem_to_cpu;
assign debug_mem_to_cpu = mem_to_cpu;
wire[31:0] address_bus;
assign debug__address_bus = address_bus;
wire write_en_bus;
assign debug_write_enable = write_en_bus;
// memory wires
wire[15:0] mem_data_demux_control_signal;


CPU cpu(
    .clk(clk),
    .rst(rst),


    .data_demux_control_signal(mem_data_demux_control_signal),
    .cpu_to_mem_data_bus(cpu_to_mem),
    .mem_to_cpu_data_bus(mem_to_cpu),
    .address_bus(address_bus),
    .write_en_bus(write_en_bus),
     

    .debug_op_dec_next_address(debug_op_dec_next_address),
    .debug_alu_result(debug_alu_result),
    .debug_alu_address_out(debug_alu_address_out),

   .debug_ccu_opcode(debug_ccu_opcode),
   .debug_ccu_optype(debug_ccu_optype),
   .debug_ccu_rd(debug_ccu_rd),
   .debug_ccu_rs1(debug_ccu_rs1),
   .debug_ccu_rs2(debug_ccu_rs2),
   .debug_ccu_imm(debug_ccu_imm),
   .debug_ccu_funct_bits(debug_ccu_funct_bits),
   .debug_plus_1_out_bits(debug_plus_1_out_bits),
   .debug_instruction_register(debug_instruction_register),
   .debug_ipc_address_to_opdec(debug_ipc_address_to_opdec),
   .debug_pc_address_to_mem(debug_pc_address_to_mem),
   .debug_cpu_address_bus_mux_signal(debug_cpu_address_bus_mux_signal)
);




MEMORY mem(
    .clk(clk),
    .rst(rst),

    .data_to_cpu(mem_to_cpu),
    .data_from_cpu(cpu_to_mem),
    .address_bus(address_bus),

    .write_en(write_en_bus),


    .sig_a(sig_a),
    .sig_b(sig_b),
    .sig_c(sig_c),
    .sig_d(sig_d),

    .stepper_step_signal(stepper_step_signal),
    .stepper_direction_signal(stepper_direction_signal),

    .servo_pulse(servo_pulse),

    .MOSI(MOSI),
    .MISO(MISO),
    .SPI_CLK(SPI_CLK),
    .slave_select(slave_select),
    
    .NRF_IRQ(NRF_IRQ),
     .mem_data_demux_control_signal(mem_data_demux_control_signal),

    .debug_enable_irom(debug_enable_irom),
    .debug_enable_ram(debug_enable_ram),
    .debug_offset(debug_offset)
);




endmodule