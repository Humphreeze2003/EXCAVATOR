module STEERING_STEPPER_MOTOR (
    input clk,
    input rst,


      //   interface
    input enable,
//    input wire[31:0] system_mode_reg_bits,
    input wire[31:0] offset,
    input wire[31:0] data_from_cpu,
    output reg[31:0] data_to_cpu,
    input write_en,

    output  pulse,


 output wire[31:0] debug_servo_control_reg,
 output wire[31:0] debug_servo_status_reg


);

// reg[31:0] data_out , data_out_next;
// assign data_to_cpu = data_out;


reg[31:0] control_reg  ,control_reg_next;
reg[31:0] status_reg  ,status_reg_next;
// reg[31:0] clock_cycles_counter;

assign debug_servo_control_reg = control_reg;
assign debug_servo_status_reg = status_reg;
wire standby = control_reg[16];
reg[31:0] microseconds_counter , microseconds_counter_next;  // 27 cycles every microsecond
wire microseconds_tick = (microseconds_counter == (control_reg[15:0] - 1'b1));
wire pulse_signal = ((microseconds_counter <= (control_reg[15:0]) - 1'b1) && state == SEND_PULSE);
assign pulse = pulse_signal;

reg[31:0] miliseconds_counter , miliseconds_counter_next;  // 27000 cycles every milisecond
wire miliseconds_tick = (miliseconds_counter == (32'd540000 - 1'b1));

reg[4:0] state , next_state;
localparam[4:0]  IDLE = 4'b0000  , WAIT=4'b0001 , SEND_PULSE = 4'b0010 ;


always @(posedge clk or negedge rst) begin
    if(!rst)begin
        // data_out <= 32'b0;
        microseconds_counter <= 32'b0;
        miliseconds_counter <= 32'b0;
        state <= IDLE;
        
        control_reg[15:0] <= 16'd1500 ;
        control_reg[31:16] <= 16'b0;
        status_reg <= 32'b0;
    end else begin
        // data_out <= data_out_next;
        if(enable)begin
            if(state == WAIT)begin
            miliseconds_counter <= (miliseconds_counter == (32'd540000 - 1'b1))?32'b0:miliseconds_counter_next;

            end else begin
                       miliseconds_counter <= miliseconds_counter_next;
 
            end

          if(state == SEND_PULSE)begin
            microseconds_counter <= (microseconds_counter >= (control_reg[15:0] - 1'b1))?32'b0:microseconds_counter_next;
            
          end else begin
                    microseconds_counter <= microseconds_counter_next;

          end

        // if(write_en)begin
        //     control_reg <= data_from_cpu;
        // end

        state <= next_state;

        if(write_en && enable)begin
            case (offset)
                0: control_reg <= data_from_cpu;
                4: status_reg  <= data_from_cpu;
                default: ;
            endcase
        end

        end
    end
end



always @(*) begin
    // data_out_next = data_out;
    data_to_cpu = 32'b0;
    control_reg_next = control_reg;
    status_reg_next = status_reg;

//    pulse = 1'b0;
     next_state = IDLE;
     miliseconds_counter_next = 1'b0;
     microseconds_counter_next = 1'b0;
    
    if(enable)begin

  if(!write_en)begin

        case (offset)
            0:begin
                data_to_cpu = control_reg;
            end

             0:begin
                data_to_cpu = status_reg;
            end
            default: data_to_cpu = 32'b0;
        endcase
end

        if(standby)begin
            next_state = IDLE;
            
        end
     
    end 
    
     case (state)
        IDLE:begin
            if(enable)begin
                next_state = WAIT;
            end else begin
                next_state = IDLE;
            end
        end 


        WAIT: begin 
           if(enable)begin
             // count 20ms
            miliseconds_counter_next = miliseconds_counter + 1'b1;
            if(miliseconds_tick)begin
                next_state = SEND_PULSE;
            end else begin
                next_state = WAIT;
            end
           end else begin
            next_state = IDLE;
           end
        end

        SEND_PULSE : begin 
          if(enable)begin
              microseconds_counter_next = microseconds_counter + 1'b1;
           if(microseconds_tick)begin
            next_state = IDLE;
           end else begin
            next_state = SEND_PULSE;
           end
             
          end else begin
            next_state = IDLE;
          end
        end


        default: next_state = IDLE;
     endcase










    // if(enable)begin
    //     if(pulse_signal)begin
    //         pulse = 1'b1
    //     end
    // end
end
    
endmodule