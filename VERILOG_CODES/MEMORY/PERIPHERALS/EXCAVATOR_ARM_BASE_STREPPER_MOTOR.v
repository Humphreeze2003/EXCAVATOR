module EXCAVATOR_ARM_BASE_STEPPER_MOTOR(
    input clk,
    input rst,


    //   interface
    input enable,
    input wire[31:0] system_mode_reg_bits
    input wire[31:0] address_bus
    input wire[31:0] data_from_cpu,
    input write_en,

    output wire step;
    output reg direction;
);





reg[31:0] control_reg;
reg[31:0] stepper_frequency_counter;

wire step_pulse_tick = (stepper_frequency_counter == (control_reg[9:1])- 1'b1);


always @(posedge clk or negedge rst) begin
      if(!rst)begin
         control_reg[9:1] <= 32'd256;
         control_reg[0] <= 1'b1;
      end else begin
        if(enable)begin
        

         if(write_en)begin
            control_reg <= data_from_cpu;
         end
        end         
      end
end


always @(*) begin
     direction = 1'b0;
     step = 1'b0;
    if(enable)begin
        direction = control_reg[0];
        if(step_pulse_tick)begin
            step = 1'b1;
        end
    end
end

endmodule