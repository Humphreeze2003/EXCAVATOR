module CPU(
    input clk,
    input rst,

    // buses 
    output wire[31:0] cpu_to_mem_data_bus,
    input wire[31:0] mem_to_cpu_data_bus,
    output wire[31:0] address_bus,
    output  write_en_bus
    


);


   // global wires
wire cpu_write_enable;
// wire[31:0] cpu_write_data_bus;
// wire[31:0] cpu_read_data_bus
// wire[31:0] cpu_address_bus


    // pc wires
wire[31:0] pc_current_address_to_op_dec;
// wire[31:0] pc_current_address;




    // ccu wires

wire[6:0] ccu_op_code;
wire[3:0] ccu_op_type;
wire[4:0] ccu_rd;
wire[4:0] ccu_rs1;
wire[4:0] ccu_rs2;
wire[31:0] ccu_immediate_value;
wire[9:0] ccu_funct_bits;



    // op_dec_wires
wire[31:0] next_instruction_address_from_op_dec;
wire[9:0] op_dec_alu_op;
wire[7:0] mux_control_signal;




    // reg file wires
wire[31:0] reg_file_read_data_1;
wire[31:0] reg_file_read_data_2; 




    // alu wires
wire[31:0] alu_result;
// wire alu_branch_taken


// mux wires
wire[31:0] mux_output;



// plus_1 wires
wire[31:0] plus_one_out;

// address bus mux wires
wire[15:0] control_signal;
wire[31:0] alu_mem_address_out;
wire[31:0] pc_mem_address_out;


CPU_ADDRESS_BUS_MUX cpu_add_mux(
 .control_signal(control_signal),
 
 .pc_val(pc_mem_address_out) , // address from pc_counter
 .alu_val(alu_mem_address_out) , // address from alu


 .mux_out(address_bus)


);

PROGRAM_COUNTER pc(
.clk(clk),
.rst(rst),
.next_address(next_instruction_address_from_op_dec), // input--------------------------from op decoder
.current_address_to_mem(pc_mem_address_out), // output =========================
.current_address_to_op_dec(pc_current_address_to_op_dec)// output  --------------------- to op decoder
//.cpu_address_bus_mux_signal(control_signal)
);







CENTRAL_CONTROL_UNIT  ccu(

    .instruction(mem_to_cpu_data_bus),




    .op_code(ccu_op_code),
    .op_type(ccu_op_type), 
    .rd(ccu_rd),
    .rs1(ccu_rs1),
    .rs2(ccu_rs2),
    .immediate_value(ccu_immediate_value),
    .funct_bits(ccu_funct_bits)
);






OP_DECODER op_dec(
    .op_code(ccu_op_code),
    .op_type(ccu_op_type),
    .funct_bits(ccu_funct_bits),
    .current_instruction_address(pc_current_address_to_op_dec),  // address of the current instruction


    .rs1(ccu_rs1),
    .rs2(ccu_rs2),
    .rd(ccu_rd),
    .immediate_value(ccu_immediate_value),

    .rs1_value(reg_file_read_data_1),
    .rs2_value(reg_file_read_data_2),
    
    
    .next_address(next_instruction_address_from_op_dec),  // address of the next instruction( goes to the program counter)
    .alu_operation(op_dec_alu_op),

    // output reg[4:0] rs1_address,  // adress to read from
    // output reg[4:0] rs2_address, // address to read from
    // output reg[4:0] rd_address,  // adress to write to

    // output reg read_en,   // not needed
    .cpu_write_en(cpu_write_enable),
    .mem_write_enable(write_en_bus),

    .mux_control_signal(mux_control_signal),
    .data_to_mem(cpu_to_mem_data_bus),
    .cpu_address_bus_mux_signal(control_signal)
);






ALU alu(
    
    .rs1(reg_file_read_data_1),
    .rs2(reg_file_read_data_2),
    .immediate(ccu_immediate_value),
    .operation(op_dec_alu_op),

    .result(alu_result),
    .mem_address(alu_mem_address_out),   //===========================================
    .instruction(mem_to_cpu_data_bus)

//    .cpu_address_bus_mux_signal(control_signal)

    // flags
    // branch_taken(alu_branch_taken)  // for when a branch is taken
);








PLUS_1 plus_one(
    .val(pc_current_address_to_op_dec), //current instruction's address
    .plus_1(plus_one_out)
);








 WRITE_BACK_MUX  write_back_mux(
    .control_signal(mux_control_signal),
    .from_alu(alu_result),
    .from_mem(mem_to_cpu_data_bus),
    .address_plus_1(plus_one_out),
    .mux_out(mux_output)
);








             
CPU_REGS  reg_file(
    .clk(clk),
    .rst(rst),

    .rs1(ccu_rs1),  // address
    .rs2(ccu_rs2), // address
    .destination_reg(ccu_rd), // address

    .write_enabled(cpu_write_enable),   ///////////////////////// from op decoder
    .write_data(mux_output), //////////////////////// from ALU
   

    .read_data1(reg_file_read_data_1), /////////////////// to ALU
    .read_data2(reg_file_read_data_2) //////////// to ALU


); 


    
endmodule