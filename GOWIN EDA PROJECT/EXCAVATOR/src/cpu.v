module CPU(
    input clk,
    input rst,

    input wire[15:0] data_demux_control_signal,

    // buses 
    output wire[31:0] cpu_to_mem_data_bus,
    input wire[31:0] mem_to_cpu_data_bus,
    output wire[31:0] address_bus,
    output  write_en_bus,
    

// debugging signals
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
   output wire[31:0] debug_ipc_address_to_opdec,
   output wire[31:0] debug_pc_address_to_mem,
   output wire[15:0] debug_cpu_address_bus_mux_signal


  
);


reg [31:0] instruction_register;
wire[31:0] instruction_register_wire;
assign debug_instruction_register = instruction_register;

always @(posedge clk or negedge rst)begin

if(!rst)begin
instruction_register <= 32'b0;


end  else begin  // posedge clk

instruction_register <= instruction_register_wire;  // store the instruction

end




end











   // global wires
wire cpu_write_enable;
// wire[31:0] cpu_write_data_bus;
// wire[31:0] cpu_read_data_bus
// wire[31:0] cpu_address_bus


    // pc wires
wire[31:0] pc_current_address_to_op_dec;
assign debug_ipc_address_to_opdec = pc_current_address_to_op_dec;
// wire[31:0] pc_current_address;




    // ccu wires

wire[6:0] ccu_op_code;
assign debug_ccu_opcode = ccu_op_code;
wire[3:0] ccu_op_type;
assign debug_ccu_optype = ccu_op_type;
wire[4:0] ccu_rd;
assign debug_ccu_rd = ccu_rd;
wire[4:0] ccu_rs1;
assign debug_ccu_rs1 = ccu_rs1;
wire[4:0] ccu_rs2;
assign debug_ccu_rs2 = ccu_rs2;
wire[31:0] ccu_immediate_value;
assign debug_ccu_imm = ccu_immediate_value;
wire[9:0] ccu_funct_bits;
assign debug_ccu_funct_bits = ccu_funct_bits;


// MEM_DATA_DEMULTIPLEXER wires

wire[31:0] to_write_back_mux;  


    // op_dec_wires
wire[31:0] next_instruction_address_from_op_dec;
assign debug_op_dec_next_address =  next_instruction_address_from_op_dec;
wire[9:0] op_dec_alu_op;
wire[7:0] mux_control_signal;




    // reg file wires
wire[31:0] reg_file_read_data_1;
wire[31:0] reg_file_read_data_2; 




    // alu wires
wire[31:0] alu_result;
assign debug_alu_result = alu_result;
// wire alu_branch_taken


// mux wires
wire[31:0] mux_output;



// plus_1 wires
wire[31:0] plus_one_out;
assign debug_plus_1_out_bits = plus_one_out;
// address bus mux wires
wire[15:0] control_signal;
assign debug_cpu_address_bus_mux_signal = control_signal;
wire[31:0] alu_mem_address_out;
assign debug_alu_address_out = alu_mem_address_out;
wire[31:0] pc_mem_address_out;
assign debug_pc_address_to_mem = pc_mem_address_out;
// new wires

//wire[31:0] mem_address_bus_mux_out_to_pc;
//wire[31:0] mem_address_bus_mux_out_to_address_bus;  

CPU_ADDRESS_BUS_MUX cpu_add_mux(
 .control_signal(control_signal),
 
// .pc_val(pc_mem_address_out) , // address from pc_counter
   .alu_val(alu_mem_address_out) , // address from alu
  .pc_val(pc_mem_address_out) , // address from pc_couneter
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





MEM_DATA_DEMULTIPLEXER data_demux(
.control_signal(data_demux_control_signal),

.data(mem_to_cpu_data_bus),  // from memory 
.to_ccu(instruction_register_wire),
.to_write_back_mux(to_write_back_mux)

);




CENTRAL_CONTROL_UNIT  ccu(

    .instruction(instruction_register),




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

    .mux_control_signal(mux_control_signal), // for write back mux
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
    .instruction(instruction_register),
    .instruction_address(pc_current_address_to_op_dec)

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
//    .from_mem(instruction_register_wire),
    .from_mem(to_write_back_mux),

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