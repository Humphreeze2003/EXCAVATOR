`timescale 1ns/1ps

module computer_tb;

    

  

    reg clk;
    reg rst;

    reg MISO;
    reg NRF_IRQ;


    

  



wire[31:0] debug__address_bus;
wire[31:0] debug_mem_to_cpu;
wire[31:0] debug_cpu_to_mem;
wire[31:0] debug_write_enable;
wire[31:0] debug_op_dec_next_address;
wire[31:0] debug_alu_result;
wire[31:0] debug_alu_address_out;

wire[31:0] debug_ccu_opcode;
wire[31:0] debug_ccu_optype;
wire[31:0] debug_ccu_rd;
wire[31:0] debug_ccu_rs1;
wire[31:0] debug_ccu_rs2;
wire[31:0] debug_ccu_imm;
wire[31:0] debug_ccu_funct_bits;
wire[31:0] debug_plus_1_out_bits;
wire[31:0] debug_instruction_register;
wire[31:0] debug_enable_irom;
wire[31:0] debug_enable_ram;
wire[31:0] debug_offset;
wire[31:0] debug_ipc_address_to_opdec;
wire[31:0] debug_pc_address_to_mem;
wire[15:0] debug_cpu_address_bus_mux_signal;
wire[31:0] debug_cpu_data_address_bus;
wire[31:0] debug_mem_fetched_data_bus;
wire[31:0] debug_op_dec_current_address_reg;
wire[31:0] debug_reg_file_read_data_1;
wire[31:0] debug_reg_file_read_data_2;
wire[31:0] debug_write_back_mux_output;
wire[31:0] debug_write_back_mux_control_signal;
wire[31:0] debug_reg_a0;
wire[31:0] debug_reg_a1;
wire[31:0] debug_reg_a2;
wire[31:0] debug_reg_a3;
wire[31:0] debug_reg_a4;
wire[31:0] debug_reg_a5;
wire[31:0] debug_reg_a6;
wire[31:0] debug_reg_a7;
wire[31:0] debug_reg_sp;
wire[31:0] debug_reg_s0;
wire[31:0] debug_reg_ra;
wire[31:0] debug_alu_operation;
wire[31:0] gebug_data_offset;
wire[31:0] debug_cpu_write_enable;


wire[31:0] debug_cpu_state;


wire[31:0] debug_dc_control_reg;
wire[31:0] debug_dc_status_reg;


wire[31:0] debug_stepper_control_reg;
wire[31:0] debug_stepper_status_reg;

wire[31:0] debug_servo_control_reg;
wire[31:0] debug_servo_status_reg;


wire[31:0] debug_system_mode_reg;
wire[31:0] debug_system_reset_reg;
wire debug_clk;

wire[31:0] debug_shifted_immediate;
// SPI DEBUGGING SIGNALS
 wire[31:0] debug_enable_spi;
 wire[31:0] debug_spi_control_reg;
 wire[31:0] debug_spi_status_reg;
 wire[31:0] debug_spi_buffer0;
 wire[31:0] debug_spi_buffer1;
 wire[31:0] debug_spi_state;
 wire[31:0] debug_bytes_to_send;
 wire[31:0] debug_bits_to_send;
 wire[31:0] debug_bits_sent;
    wire sig_a;
    wire sig_b;
    wire sig_c;
    wire sig_d;

    wire stepper_step_signal;
    wire stepper_direction_signal;

    wire servo_pulse;

    wire MOSI;
    wire SPI_CLK;
    wire slave_select;


    

  

    COMPUTER uut (
        .clk(clk),
        .rst(rst),

        .debug__address_bus(debug__address_bus),
        .debug_mem_to_cpu(debug_mem_to_cpu),
        .debug_cpu_to_mem(debug_cpu_to_mem),
        .debug_write_enable(debug_write_enable),
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
        .debug_enable_irom(debug_enable_irom),
        .debug_enable_ram(debug_enable_ram),
        .debug_offset(debug_offset),
        .debug_ipc_address_to_opdec(debug_ipc_address_to_opdec),
        .debug_pc_address_to_mem(debug_pc_address_to_mem),
        .debug_cpu_address_bus_mux_signal(debug_cpu_address_bus_mux_signal),
        .debug_cpu_data_address_bus(debug_cpu_data_address_bus),
        .debug_mem_fetched_data_bus(debug_mem_fetched_data_bus),
        .debug_op_dec_current_address_reg(debug_op_dec_current_address_reg),
        .debug_reg_file_read_data_1(debug_reg_file_read_data_1),
        .debug_reg_file_read_data_2(debug_reg_file_read_data_2),
        .debug_write_back_mux_output(debug_write_back_mux_output),
        .debug_write_back_mux_control_signal(debug_write_back_mux_control_signal),
        .debug_reg_a0(debug_reg_a0),
        .debug_reg_a1(debug_reg_a1),
        .debug_reg_a2(debug_reg_a2),
        .debug_reg_a3(debug_reg_a3),
        .debug_reg_a4(debug_reg_a4),
        .debug_reg_a5(debug_reg_a5),
        .debug_reg_a6(debug_reg_a6),
        .debug_reg_a7(debug_reg_a7),
        .debug_reg_sp(debug_reg_sp),
        .debug_reg_s0(debug_reg_s0),
        .debug_reg_ra(debug_reg_ra),
        .gebug_data_offset(gebug_data_offset),
        .debug_alu_operation(debug_alu_operation),
        .debug_cpu_write_enable(debug_cpu_write_enable),
        .debug_cpu_state(debug_cpu_state),

        .debug_dc_control_reg(debug_dc_control_reg),
        .debug_dc_status_reg(debug_dc_status_reg),

        .debug_stepper_control_reg(debug_stepper_control_reg),
        .debug_stepper_status_reg(debug_stepper_status_reg),


        .debug_servo_control_reg(debug_servo_control_reg),
        .debug_servo_status_reg(debug_servo_status_reg),


       .debug_system_mode_reg(debug_system_mode_reg),
       .debug_system_reset_reg(debug_system_reset_reg),

       .debug_shifted_immediate(debug_shifted_immediate),

       .debug_clk(debug_clk),
// SPI DEBUGGING SIGNALS

   .debug_enable_spi(debug_enable_spi),
   .debug_spi_control_reg(debug_spi_control_reg),
   .debug_spi_status_reg(debug_spi_status_reg),
   .debug_spi_buffer0(debug_spi_buffer0),
   .debug_spi_buffer1(debug_spi_buffer1),
   .debug_spi_state(debug_spi_state),
   .debug_bytes_to_send(debug_bytes_to_send),
   .debug_bits_to_send(debug_bits_to_send), 
   .debug_bits_sent(debug_bits_sent),

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



  


   

   

//    initial begin
//        clk = 1;

//        forever #18.5185 clk = ~clk;
//    end


    

 

    initial begin


//        rst = 0;
        MISO = 0;
        NRF_IRQ = 1;


        #5;
       
       
     
//        rst = 1;

//        NRF_IRQ = 0;
//      #200000
//      NRF_IRQ = 1;
        #20000000;

        $finish;
    end




initial begin
    clk = 0;
    rst = 1;

    #1;
    rst = 0;       // triggers asynchronous reset
    clk = 1;
    #18.5185;
    rst = 1;       // release reset
    clk = 0;
            forever #18.5185 clk = ~clk;

end
    

    initial begin

        $dumpfile("computer.vcd");

        $dumpvars(0, computer_tb);

    end


always@(debug__address_bus)begin

if (((debug__address_bus >= 32'h0000045f) && (debug__address_bus <= 32'h00000468)))begin

    $display(
        "TRACE | time=%0t | address = 0x%08h " ,   $time , debug__address_bus );
end
end

//always @(debug__address_bus) begin


//if (
//    ((debug__address_bus >= 32'h000002C0) &&
//     (debug__address_bus <= 32'h000003F7))
//    ||
//    ((debug__address_bus >= 32'h00000100) &&
//     (debug__address_bus <= 32'h0000011D))
//)
//begin

//    $display(
//        "TRACE | time=%0t | PC=0x%08h | BYTE=0x%08h | INSTR=0x%08h | a0=0x%08h a1=0x%08h a2=0x%08h a3=0x%08h a4=0x%08h a5=0x%08h | s0 = 0x%08h | fetched_data = 0x%08h | rd=0x%08h | rs1=0x%08h | rs2=0x%08h | next=0x%08h | imm=0x%08h | ALU_OP=0x%08h | address_for_data_fetch = 0x%08h | write_back_mux_control_signal = 0x%08h",
//        
//        $time,
//        debug__address_bus,
//        debug__address_bus * 4,
//        debug_instruction_register,

//        debug_reg_a0,
//        debug_reg_a1,
//        debug_reg_a2,
//        debug_reg_a3,
//        debug_reg_a4,
//        debug_reg_a5,
//        debug_reg_s0,
//        debug_mem_fetched_data_bus,
//        debug_ccu_rd,
//        debug_reg_file_read_data_1,
//        debug_reg_file_read_data_2,
//        debug_op_dec_next_address,
//        debug_ccu_imm,
//        debug_alu_operation,
//        debug_cpu_data_address_bus,
//        debug_write_back_mux_control_signal  
//);

//end
//end
endmodule