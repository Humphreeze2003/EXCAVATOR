module DC_DRIVER_MOTOR(
    input clk,
    input rst,

     // interface
    input enable,
    input wire[31:0] offset,
    input wire[31:0] data_from_cpu,
    output reg[31:0] data_to_cpu,
    input wire write_en,


    input wire[31:0] system_mode_reg_bits,


    output signal_A,
    output signal_B,
    output signal_C,
    output signal_D
);


reg data_out , data_out_next;
assign data_to_cpu = data_out;

// localparam[31:0]  DC_PERIPHERAL_BASE_ADDRESS = 32'd3071 ;

// buffer for system mode reg
wire[31:0] sys_reg_buffer = (enable)?system_mode_reg_bits;

reg[31:0] control_reg , control_reg_next;
reg[31:0] status_reg , status_reg_next;
wire standby = control_reg[10]; // when no key is pressed
// / PWM generation signals
reg[31:0] motor_frequency_counter;
reg motor_pulse_tick;
assign motor_pulse_tick = (motor_frequency_counter >= (control_reg[9:1])/2);

reg sig_a , sig_a_next;
reg sig_b , sig_b_next;
reg sig_c , sig_c_next;
reg sig_d , sig_d_next;

assign signal_A = sig_a;
assign signal_B = sig_b;
assign signal_C = sig_c;
assign signal_D = sig_d;




always @(posedge clk or negedge rst) begin
      if(!rst)begin
        data_out <= 32'b0;
        control_reg[9:1] <= 32'd256;
        control_reg[0] <= 1'b1;
        
        sig_a <= 1'b0;
        sig_b <= 1'b0;
        sig_c <= 1'b0;
        sig_c <= 1'b0;

        motor_frequency_counter <= 1'b0;
        // motor_pulse_tick <= 1'b0;
      end else begin
        data_out <= data_out_next;
        control_reg <= control_reg_next;
        status_reg <= status_reg_next;
        if(enable)begin
      motor_frequency_counter <= (motor_frequency_counter >= (control_reg[9:1])-1'b1)?1'b0:motor_frequency_counter+1'b1;
      if(write_en)begin
        // writes are synchronous
       case (offset)
        0: control_reg <= data_from_cpu;
        1: status_reg <= data_from_cpu; 
        default: 
       endcase
      end

        end

      end
end


always @(*) begin
  data_out_next = data_out;
  control_reg_next = control_reg;
  status_reg_next = status_reg;
    sig_a_next = 0;
    sig_b_next = 0;
    sig_c_next = 0;
    sig_d_next = 0;

if(enable)begin // mode 1 = drive
  
if(!write_en )begin
   case (offset)
    0: data_out_next = control_reg;
    1: data_out_next = status_reg;
    default:  data_out_next = 32'b0;
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