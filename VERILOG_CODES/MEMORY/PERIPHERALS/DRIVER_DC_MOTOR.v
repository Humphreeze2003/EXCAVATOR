module DC_DRIVER_MOTOR(
    input clk,
    input rst,

     // interface
    input enable,
    input wire[31:0] offset,
    input wire[31:0] data_from_cpu,
    output reg[31:0] data_to_cpu,
    input wire write_en,


//    input wire[31:0] system_mode_reg_bits,


    output signal_A,
    output signal_B,
    output signal_C,
    output signal_D,

    output wire[31:0] debug_dc_control_reg,
    output wire[31:0] debug_dc_status_reg

);


reg[31:0] data_out , data_out_next;
// assign data_to_cpu = data_out;

// localparam[31:0]  DC_PERIPHERAL_BASE_ADDRESS = 32'd3071 ;

// buffer for system mode reg
//wire[31:0] sys_reg_buffer = (enable)?system_mode_reg_bits:32'b0;

reg[31:0] control_reg , control_reg_next;
reg[31:0] status_reg , status_reg_next;
wire standby = control_reg[10]; // when no key is pressed
// / PWM generation signals
reg[31:0] motor_frequency_counter;
wire motor_pulse_tick;
assign motor_pulse_tick = (motor_frequency_counter >= (control_reg[9:1])/2);

reg sig_a , sig_a_next;
reg sig_b , sig_b_next;
reg sig_c , sig_c_next;
reg sig_d , sig_d_next;

assign signal_A = sig_a;
assign signal_B = sig_b;
assign signal_C = sig_c;
assign signal_D = sig_d;

assign debug_dc_control_reg = control_reg;
assign debug_dc_status_reg = status_reg;



always @(posedge clk or negedge rst) begin
      if(!rst)begin
        // data_out <= 32'b0;
        control_reg[9:1] <= 32'd256;
        control_reg[0] <= 1'b1;
        control_reg[31:10] <= 32'b0;
        status_reg <= 32'b0;
        sig_a <= 1'b0;
        sig_b <= 1'b0;
        sig_c <= 1'b0;
        sig_d <= 1'b0;

        motor_frequency_counter <= 1'b0;
        // motor_pulse_tick <= 1'b0;
      end else begin
       
        if(enable)begin
      motor_frequency_counter <= (motor_frequency_counter >= (control_reg[9:1])-1'b1)?1'b0:motor_frequency_counter+1'b1;
      if(write_en)begin
        // writes are synchronous
       case (offset)
        0: control_reg <= data_from_cpu;
        4: status_reg <= data_from_cpu; 
        default: ;
       endcase
      end else begin
        control_reg <= control_reg_next;
        status_reg <= status_reg_next;
      end

      sig_a <= sig_a_next;
      sig_b <= sig_b_next;
      sig_c <= sig_c_next;
      sig_d <= sig_d_next;

        end else begin

        // data_out <= data_out_next;
        

      sig_a <= 1'b0;
      sig_b <= 1'b0;
      sig_c <= 1'b0;
      sig_d <= 1'b0;
           end
      end
end


always @(*) begin
  // data_out_next = data_out;
  data_to_cpu = 32'b0;
  control_reg_next = control_reg;
  status_reg_next = status_reg;
    sig_a_next = 0;
    sig_b_next = 0;
    sig_c_next = 0;
    sig_d_next = 0;

if(enable)begin // mode 1 = drive

  if(!write_en)begin
   case (offset)
    0:begin
      data_to_cpu = control_reg;
    end

    4: begin
      data_to_cpu = status_reg;
    end
    default: data_to_cpu = 32'b0;
   endcase
end
   
   if(!standby)begin
       if(control_reg[0] == 1 && motor_pulse_tick)begin // clockwise
    sig_a_next = 1;
    sig_b_next = 0;
    sig_c_next = 0;
    sig_d_next = 1;
end else if(control_reg[0] == 0 && motor_pulse_tick)begin  // anti_clockwise
    sig_a_next = 0;
    sig_b_next = 1;
    sig_c_next = 1;
    sig_d_next = 0;
end
   end else begin
    sig_a_next = 0;
    sig_b_next = 0;
    sig_c_next = 0;
    sig_d_next = 0;
   end

end

end

endmodule