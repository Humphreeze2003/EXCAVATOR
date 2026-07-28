module DC_DRIVER_MOTOR(
    input clk,
    input rst,

     // interface
    input enable,
    input wire[31:0] address_bus,
    input wire[31:0] data_from_cpu,
    input wire write_en,
    input wire[31:0] system_mode_reg_bits


    output signal_A,
    output signal_B,
    output signal_C,
    output signal_D
);



localparam[31:0]  DC_PERIPHERAL_BASE_ADDRESS = 32'd3071 ;

reg[31:0] control_reg;

// / PWM generation signals
reg[31:0] motor_frequency_counter;
reg motor_pulse_tick;
assign motor_pulse_tick = (motor_frequency_counter == (control_reg[9:1])-1'b1);

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
        control_reg[9:1] <= 32'd256;
        control_reg[0] <= 1'b1;
        sig_a <= 1'b0;
        sig_b <= 1'b0;
        sig_c <= 1'b0;
        sig_c <= 1'b0;

        motor_frequency_counter <= 1'b0;
        // motor_pulse_tick <= 1'b0;
      end else begin
        if(enable)begin
      motor_frequency_counter <= (motor_frequency_counter >= (control_reg[9:1])-1'b1)?1'b0:motor_frequency_counter+1'b1;
      if(write_en)begin
        // writes are synchronous
        control_reg <= data_from_cpu;
      end

        end

      end
end


always @(*) begin
    sig_a_next = 0;
    sig_b_next = 0;
    sig_c_next = 0;
    sig_d_next = 0;

if(enable)begin
//   if(system_mode_reg_bits == 32'b0)begin
//         sig_a_next = 0;
//         sig_b_next = 0;
//         sig_c_next = 0;
//         sig_d_next = 0;
// end else 

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
end

end

endmodule