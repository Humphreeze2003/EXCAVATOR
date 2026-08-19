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



  


   

   

    initial begin
        clk = 0;

        forever #18.5185 clk = ~clk;
    end


    

 

    initial begin


        rst = 0;
        MISO = 0;
        NRF_IRQ = 1;


        #20;
       
        rst = 1;


        #20000000;

        $finish;
    end



    

    initial begin

        $dumpfile("computer.vcd");

        $dumpvars(0, computer_tb);

    end

endmodule