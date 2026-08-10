module ADDRESS_DECODER(
    input clk,
    input rst,


    input wire[31:0] address_bus,

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
    
    output wire[31:0] offset

);

reg[]

localparam[31:0]  = RODATA_BASE = 32'd2303 , RODATA_END = 32'd2558,
                    I_ROM_BASE = 32'd256 , I_ROM_END = 32'd2302, 
                    DC_MOTOR_BASE  = 32'd3071, DC_MOTOR_END = 32'd3102, 
                    STEPPER_BASE = 32'd3103, STEPPER_END = 32'd3134,
                    SERVO_BASE  = 32'd3135,  SERVO_END = 32'd3166,
                    NRF_BASE  = 32'd3199,  NRF_END = 32'd3230,
                    SPI_BASE = 332'd167, SPI_END = 32'd3198,
                    SYST_REGS_BASE = 32'd3231 , SYST_REGS_END = 32'd3262,
                    RAM_BASE = 32'd0 , RAM_END = 32'd255;



wire is_rodata = (address_bus >= RODATA_BASE && address_bus <= RODATA_END);
wire is_irom = (address_bus >= I_ROM_BASE && address_bus <= I_ROM_END);
wire is_dc_motor = (address_bus >= DC_MOTOR_BASE && address_bus <= DC_MOTOR_END);
wire is_stepper_motor = (address_bus >= STEPPER_BASE && address_bus <= STEPPER_END);
wire is_servo = (address_bus >= SERVO_BASE && address_bus <= SERVO_END);
wire is_nrf = (address_bus >= NRF_BASE && address_bus <= NRF_END) ;
wire is_spi = (address_bus >= SPI_BASE && address_bus <= SPI_END);
wire is_sys_regs = (address_bus >= SYST_REGS_BASE && address_bus <= SYST_REGS_END);
wire is_ram = (address_bus >= RAM_BASE && address_bus <= RAM_END);


assign enable_rodata = is_rodata;
assign enable_instruction_rom = is_irom;
assign enable_RAM = is_ram;
assign enable_driver_dc_motor = is_dc_motor;
assign enable_stepper_motor = is_stepper_motor;
assign enable_servo_motor = is_servo;
assign enable_nrf = is_nrf;
assign enable_spi = is_spi;
assign enable_system_regs = is_sys_regs;


assign offset = (is_rodata)?(address_bus - RODATA_BASE):(is_irom)?(address_bus - I_ROM_BASE):(is_dc_motor)?(address_bus - DC_MOTOR_BASE):(is_stepper_motor)?(address_bus - STEPPER_BASE):(is_servo)?(address_bus - SERVO_BASE):(is_nrf)?(address_bus - NRF_BASE):(is_spi)?(address_bus - SPI_BASE):(is_sys_regs)?(address_bus - SYST_REGS_BASE):32'b0;





endmodule