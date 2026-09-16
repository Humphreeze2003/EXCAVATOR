module CPU(
    input clk,
    input rst,

    input wire[15:0] data_demux_control_signal,

    // buses 
    output wire[31:0] cpu_to_mem_data_bus,
    input wire[31:0] mem_to_cpu_data_bus,  // instruction fetched
    output wire[31:0] address_bus,  // for instructions fetch
    output  write_en_bus,

                    ////////////////////////##############

    output wire[31:0] data_address_bus, // for data fetch
    input wire[31:0] fetched_data,   // data fetched from memory   
    

// debugging signals
   output wire[31:0] debug_op_dec_next_address,
   output wire[31:0] debug_op_dec_current_address_reg,
   output wire[31:0] debug_alu_result,
   output wire[31:0] debug_alu_address_out,

   output wire[31:0] debug_shifted_immediate,
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
   output wire[15:0] debug_cpu_address_bus_mux_signal,
   output wire[31:0] debug_reg_file_read_data_1,
   output wire[31:0] debug_reg_file_read_data_2,
   output wire[31:0] debug_write_back_mux_output,
   output wire[31:0] debug_write_back_mux_control_signal,

output wire[31:0] debug_reg_a0,
output wire[31:0] debug_reg_a1,
output wire[31:0] debug_reg_a2,
output wire[31:0] debug_reg_a3,
output wire[31:0] debug_reg_a4,
output wire[31:0] debug_reg_a5,
output wire[31:0] debug_reg_a6,
output wire[31:0] debug_reg_a7,
output wire[31:0] debug_reg_sp,
output wire[31:0] debug_reg_s0,
output wire[31:0] debug_reg_ra,
output wire[31:0] debug_alu_operation,
output wire[31:0] debug_cpu_write_enable,
   output[31:0] debug_cpu_state
);


reg [31:0] instruction_register;
//wire[31:0] instruction_register_wire;
assign debug_instruction_register = instruction_register;


// synchroizing stages for current pc adress to op dec signals

reg[31:0] current_pc_address_to_op_dec_stage_1;
//reg[31:0] current_pc_address_to_op_dec_stage_2;
reg[31:0] current_pc_address_to_op_dec_stage_3;

wire[31:0] current_pc_address_to_op_dec_wire;


always @(posedge clk or negedge rst)begin

if(!rst)begin  
 current_pc_address_to_op_dec_stage_1 <= 32'd1130;
// current_pc_address_to_op_dec_stage_2 <= 32'd1130;
 current_pc_address_to_op_dec_stage_3 <= 32'd1130;

end  else begin

 current_pc_address_to_op_dec_stage_1 <= current_pc_address_to_op_dec_wire;
// current_pc_address_to_op_dec_stage_2 <= current_pc_address_to_op_dec_stage_1;
 current_pc_address_to_op_dec_stage_3 <= current_pc_address_to_op_dec_stage_1;



end


end




assign debug_ipc_address_to_opdec = current_pc_address_to_op_dec_wire;

assign debug_op_dec_current_address_reg = current_pc_address_to_op_dec_stage_3;



// synchroizing stages for next address from op dec to PC

reg[31:0] next_adress_to_pc_stage_1;
//reg[31:0] next_adress_to_pc_stage_2;  // skip stage 2 to remove 1 stage
reg[31:0] next_adress_to_pc_stage_3;


always @(posedge clk or negedge rst)begin


if(!rst)begin
     next_adress_to_pc_stage_1 <= 32'd1130;
//     next_adress_to_pc_stage_2 <= 32'd1130;
     next_adress_to_pc_stage_3 <= 32'd1130;

end else begin 
         next_adress_to_pc_stage_1 <= next_instruction_address_from_op_dec ;
//         next_adress_to_pc_stage_2 <= next_adress_to_pc_stage_1 ;
         next_adress_to_pc_stage_3 <=  next_adress_to_pc_stage_1;

end



end









always @(posedge clk or negedge rst)begin

if(!rst)begin
instruction_register <= 32'b0;


end  else begin  // posedge clk

//instruction_register <= instruction_register_wire;  // store the instruction
instruction_register <= mem_to_cpu_data_bus;  // store the instruction

end




end











   // global wires
wire cpu_write_enable;
assign debug_cpu_write_enable = cpu_write_enable;
// wire[31:0] cpu_write_data_bus;
// wire[31:0] cpu_read_data_bus
// wire[31:0] cpu_address_bus


    // pc wires
wire[31:0] pc_current_address_to_op_dec;
//assign debug_ipc_address_to_opdec = pc_current_address_to_op_dec;
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
assign debug_alu_operation = op_dec_alu_op;
wire[7:0] mux_control_signal;
assign debug_write_back_mux_control_signal = mux_control_signal;



    // reg file wires
wire[31:0] reg_file_read_data_1;
wire[31:0] reg_file_read_data_2; 
assign debug_reg_file_read_data_1 = reg_file_read_data_1;
assign debug_reg_file_read_data_2 = reg_file_read_data_2;



    // alu wires
wire[31:0] alu_result;
assign debug_alu_result = alu_result;
// wire alu_branch_taken


// mux wires
wire[31:0] mux_output;  // output for write back mux
assign debug_write_back_mux_output = mux_output;


// plus_1 wires
wire[31:0] plus_one_out;
assign debug_plus_1_out_bits = plus_one_out;




// address bus mux wires
wire[15:0] control_signal;
assign debug_cpu_address_bus_mux_signal = control_signal;
wire[31:0] alu_mem_address_out;
assign debug_alu_address_out = data_address_bus;
wire[31:0] pc_mem_address_out;
assign debug_pc_address_to_mem = pc_mem_address_out;



//always @(posedge clk) begin
//    if(cpu_write_enable) begin
//        $display(
//            "WRITEBACK | time=%0t | instruction=0x%08h | rd=x%0d |  cpu_write_enable=%b | Write_back_mux_conrol_signal=%0d | ALU_ressult=0x%08h | MEM_fetched_data=0x%08h | Write_back_mux_output=0x%08h",
//            
//            $time,
//            instruction_register,
//            ccu_rd,
//            cpu_write_enable,
//            mux_control_signal,
//            alu_result,
//            fetched_data,
//            mux_output
//        );
//    end
//end



// new wires

//wire[31:0] mem_address_bus_mux_out_to_pc;
//wire[31:0] mem_address_bus_mux_out_to_address_bus;  













                           //       finite state machine


// for detecting instruction address changes ,we will use current_pc_address_to_op_dec_wire and current_pc_address_to_op_dec_stage_1 ad our change detector
reg[31:0] state , next_state;
reg[31:0] cycles_counter , cycles_counter_next;
reg[31:0] execute_cycles_counter , execute_cycles_counter_next;
localparam[31:0] FETCHING = 32'd0 , 
                 DECODE_EXECUTE = 32'd1;
    





always @(posedge clk or negedge rst)begin

if(!rst)begin
  state <= FETCHING;
  cycles_counter <= 32'b0;
   execute_cycles_counter <= 32'b0;

end  else begin  
   state <= next_state;
   cycles_counter <= cycles_counter_next;
   if(state == DECODE_EXECUTE)begin

   execute_cycles_counter <= execute_cycles_counter_next;

end else begin
   execute_cycles_counter <= 32'b0;
 end

end


end




always @(*) begin
next_state = FETCHING;
cycles_counter_next = 32'b0;
execute_cycles_counter_next = execute_cycles_counter;

case(state)

//IDLE:begin  
// if(current_pc_address_to_op_dec_wire != current_pc_address_to_op_dec_stage_1)begin  
//  next_state = FETCHING;

//end else begin 
//   next_state = IDLE;
// end


//end



FETCHING: begin
// if(current_pc_address_to_op_dec_wire != current_pc_address_to_op_dec_stage_1)begin  

   if(cycles_counter < 32'd1) begin 
     cycles_counter_next = cycles_counter + 1'b1;
     next_state = FETCHING;
 end else begin 
     cycles_counter_next = 32'b0;
      next_state = DECODE_EXECUTE;
end

//end else begin
   
// end
end



DECODE_EXECUTE: begin  
  if(execute_cycles_counter < 3)begin 
    execute_cycles_counter_next = execute_cycles_counter + 1'b1;
    next_state = DECODE_EXECUTE;
end else begin 
next_state = FETCHING;
    execute_cycles_counter_next = 32'b0;


 end

end



endcase









end








assign debug_cpu_state = state;




























































//CPU_ADDRESS_BUS_MUX cpu_add_mux(
// .control_signal(control_signal),
// 
// .pc_val(pc_mem_address_out) , // address from pc_counter
//   .alu_val(alu_mem_address_out) , // address from alu
//  .pc_val(pc_mem_address_out) , // address from pc_couneter
//  .mux_out(address_bus)

//);




PROGRAM_COUNTER pc(
.clk(clk),
.rst(rst),
.cpu_fsm_state(state),
.execute_cycles_counter(execute_cycles_counter),
.next_address(next_instruction_address_from_op_dec), // input--------------------------from op decoder
//.current_address_to_mem(pc_mem_address_out), // output =========================
.current_address_to_mem(address_bus), // output =========================
//.current_address_to_op_dec(pc_current_address_to_op_dec)// output  --------------------- to op decoder
 .current_address_to_op_dec( current_pc_address_to_op_dec_wire)// output  --------------------- to op decoder                                            
//.cpu_address_bus_mux_signal(control_signal)
);





//MEM_DATA_DEMULTIPLEXER data_demux(
//.control_signal(data_demux_control_signal),

//.data(mem_to_cpu_data_bus),  // from memory 
//.to_ccu(instruction_register_wire),
//.to_write_back_mux(to_write_back_mux)

//);




CENTRAL_CONTROL_UNIT  ccu(

    .instruction(instruction_register),

//    .instruction(mem_to_cpu_data_bus),


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
//    .current_instruction_address(pc_current_address_to_op_dec),  // address of the current instruction
.current_instruction_address(current_pc_address_to_op_dec_stage_3),

    .rs1(ccu_rs1),
    .rs2(ccu_rs2),
    .rd(ccu_rd),
    .immediate_value(ccu_immediate_value),

    .rs1_value(reg_file_read_data_1),
    .rs2_value(reg_file_read_data_2),
    
    .cpu_fsm_state(state),
    .execute_cycles_counter(execute_cycles_counter),
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
    .cpu_address_bus_mux_signal(control_signal),
    .shifted_immediate(debug_shifted_immediate)
);






ALU alu(
    
    .rs1(reg_file_read_data_1),
    .rs2(reg_file_read_data_2),
    .immediate(ccu_immediate_value),
    .operation(op_dec_alu_op),
    .cpu_fsm_state(state),
    .result(alu_result),
//    .mem_address(alu_mem_address_out),   //===========================================
     .mem_address(data_address_bus),
    .instruction(instruction_register),
//     .instruction(mem_to_cpu_data_bus),
//    .instruction_address(pc_current_address_to_op_dec)
    .instruction_address(current_pc_address_to_op_dec_stage_3)

//    .cpu_address_bus_mux_signal(control_signal)

    // flags
    // branch_taken(alu_branch_taken)  // for when a branch is taken
);








PLUS_1 plus_one(
//    .val(pc_current_address_to_op_dec), //current instruction's address
    .val(current_pc_address_to_op_dec_stage_3),  //current instruction's address
    .plus_1(plus_one_out)
);








 WRITE_BACK_MUX  write_back_mux(
    .control_signal(mux_control_signal),
    .from_alu(alu_result),
//    .from_mem(instruction_register_wire),
//    .from_mem(to_write_back_mux),
     .from_mem(fetched_data),

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
    .read_data2(reg_file_read_data_2), //////////// to ALU
  

    .reg_a0(debug_reg_a0),
    .reg_a1(debug_reg_a1),
    .reg_a2(debug_reg_a2),
    .reg_a3(debug_reg_a3),
    .reg_a4(debug_reg_a4),
    .reg_a5(debug_reg_a5),
    .reg_a6(debug_reg_a6),
    .reg_a7(debug_reg_a7),
    .reg_sp(debug_reg_sp),
    .reg_s0(debug_reg_s0),
    .reg_ra(debug_reg_ra)

); 





endmodule

//$display