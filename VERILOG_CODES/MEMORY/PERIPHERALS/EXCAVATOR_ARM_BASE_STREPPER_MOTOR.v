module EXCAVATOR_ARM_BASE_STEPPER_MOTOR(
    input clk,
    input rst,


    //   interface
    input enable,
    input wire[31:0] system_mode_reg_bits,
    input wire[31:0] offset,
    input wire[31:0] data_from_cpu,
    output wire[31:0] data_to_cpu,

    input write_en,

    output wire step;
    output wire direction;
);


reg data_out , data_out_next;
assign data_to_cpu = data_out;

reg[31:0] syst_mod_bts_buffer;

reg[31:0] control_reg , control_reg_next;
reg[31:0] status_reg , status_reg_next;

wire standby = control_reg[10]; // when no key is pressed

assign direction = control_reg[0];



wire freq_counter_val = control_reg[9:1];


reg[31:0] period_counter , period_counter_next;
wire enable_period_counter = (enable);
wire step_tick = (period_counter >= freq_counter_val/2);




always @(posedge clk or negedge rst) begin
     if(!rst)begin
                data_out <= 32'b0;

        control_reg[0] <= 1'b1;
        control_reg[9:1] <= 8'256;

     end else begin

                data_out <= data_out_next;

         control_reg <= control_reg_next;
         status_reg <= status_reg_next;
         
         if(enable_period_counter)begin
            period_counter <= (period_counter >= (freq_counter_val - 1'b1))?32'b0:period_counter_next;
         end

          if(enable && write_en)begin
            case (offset)
                0: control_reg <= data_from_cpu;
                1: status_reg <= data_from_cpu;
                default: 
            endcase
        end

         period_counter <= period_counter_next;

    
    
     end
end


always @(*) begin
      data_out_next = data_out;

    control_reg_next = control_reg;
    status_reg_next = status_reg;
    period_counter_next = 1'b0;

    if(enable)begin
        if(!standby)begin
        period_counter_next = period_counter + 1'b1;
        end
   
        if(!write_en)begin
   case (offset)
    0: data_out_next = control_reg;
    1: data_out_next = status_reg;
    default:  data_out_next = 32'b0;

   endcase
end
    end
end

endmodule