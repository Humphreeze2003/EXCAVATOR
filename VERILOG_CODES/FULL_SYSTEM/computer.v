module COMPUTER(
    input clk,
    input rst,

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
output wire MISO,
output wire SPI_CLK,
output wire slave_select,


  // NRF outputs / inputs
    imput NRF_IRQ
);

// cpu wires
wire[31:0] cpu_to_mem;
wire[31:0] mem_to_cpu;
wire[31:0] address_bus;
wire write_en_bus;


CPU cpu(
    .clk(clk),
    .rst(rst),

    .cpu_to_mem_data_bus(cpu_to_mem),
    .mem_to_cpu_data_bus(mem_to_cpu),
    .address_bus(address_bus),
    .write_en_bus(write_en_bus)
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
    
    .NRF_IRQ(NRF_IRQ)
);




endmodule