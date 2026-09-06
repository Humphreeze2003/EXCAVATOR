module ADDRESS_DECODER(
    input clk,
    input rst,


    input wire[31:0] address_bus, // for instruction


                  ////////////////////////##############
   input wire[31:0] data_addresss,
   output wire[31:0] data_offset,

    output enable_rodata,
    output  enable_instruction_rom,
    output  enable_RAM,

    // output reg enable_,
    // output reg enable_rodata,
    // output reg enable_rodata,

            // enable pins for memoty mmapped peripherals
    output  enable_driver_dc_motor,
    output  enable_stepper_motor,
    output  enable_servo_motor,
    output  enable_nrf,
    output  enable_spi,
              
    output  enable_system_regs,
    
    output wire[31:0] offset,
    output wire[15:0] mem_to_cpu_data_mux_sig,




    output wire[15:0] mem_data_demux_control_signal

);



localparam[31:0]   RODATA_BASE = 32'd2303 , RODATA_END = 32'd2558,
                    I_ROM_BASE = 32'd256 , I_ROM_END = 32'd2302, 
                    DC_MOTOR_BASE  = 32'd3071, DC_MOTOR_END = 32'd3102, 
                    STEPPER_BASE = 32'd3103, STEPPER_END = 32'd3134,
                    SERVO_BASE  = 32'd3135,  SERVO_END = 32'd3166,
                    NRF_BASE  = 32'd3199,  NRF_END = 32'd3230,
                    SPI_BASE = 32'd3167, SPI_END = 32'd3198,
                    SYST_REGS_BASE = 32'd3231 , SYST_REGS_END = 32'd3262,
                    RAM_BASE = 32'd0 , RAM_END = 32'd255;



wire is_irom = (address_bus >= I_ROM_BASE && address_bus <= I_ROM_END);


wire is_rodata = (data_addresss >= RODATA_BASE && data_addresss <= RODATA_END);
wire is_dc_motor = (data_addresss >= DC_MOTOR_BASE && data_addresss <= DC_MOTOR_END);
wire is_stepper_motor = (data_addresss >= STEPPER_BASE && data_addresss <= STEPPER_END);
wire is_servo = (data_addresss >= SERVO_BASE && data_addresss <= SERVO_END);
wire is_nrf = (data_addresss >= NRF_BASE && data_addresss <= NRF_END) ;
wire is_spi = (data_addresss >= SPI_BASE && data_addresss <= SPI_END);
wire is_sys_regs = (data_addresss >= SYST_REGS_BASE && data_addresss <= SYST_REGS_END);
wire is_ram = (data_addresss >= RAM_BASE && data_addresss <= RAM_END);



assign enable_rodata = is_rodata;
assign enable_instruction_rom = is_irom;
assign enable_RAM = is_ram;
assign enable_driver_dc_motor = is_dc_motor;
assign enable_stepper_motor = is_stepper_motor;
assign enable_servo_motor = is_servo;
assign enable_nrf = is_nrf;
assign enable_spi = is_spi;
assign enable_system_regs = is_sys_regs;


assign offset = (is_irom)?(address_bus - I_ROM_BASE):32'b0; // for instructions
assign data_offset = (is_rodata)?(data_addresss - RODATA_BASE):(is_dc_motor)?(data_addresss - DC_MOTOR_BASE):(is_stepper_motor)?(data_addresss - STEPPER_BASE):(is_servo)?(data_addresss - SERVO_BASE):(is_nrf)?(data_addresss - NRF_BASE):(is_spi)?(data_addresss - SPI_BASE):(is_sys_regs)?(data_addresss - SYST_REGS_BASE):is_ram?( data_addresss - RAM_BASE):32'b0;





assign mem_data_demux_control_signal = (is_irom)?16'd1:16'd2;  // controls if data goes to ccu or write back mux ( not needed since we will now have separate buses for instructions and data
//assign mem_to_cpu_data_mux_sig = (is_rodata)?16'd3:(is_irom)?16'd1:(is_dc_motor)?16'd4:(is_stepper_motor)?16'd5:(is_servo)?16'd6:(is_nrf)?16'd7:(is_spi)?16'd8:(is_sys_regs)?16'd9:(is_ram)?16'd2:32'b0; 
// removed irom since there are now separate lines/buses for instructions and data
assign mem_to_cpu_data_mux_sig = (is_rodata)?16'd3:(is_dc_motor)?16'd4:(is_stepper_motor)?16'd5:(is_servo)?16'd6:(is_nrf)?16'd7:(is_spi)?16'd8:(is_sys_regs)?16'd9:(is_ram)?16'd2:32'b0; 




endmodule