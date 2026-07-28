module STEERING_STEPPER_MOTOR (
    input clk,
    input rst,


      //   interface
    input enable,
    input wire[31:0] system_mode_reg_bits
    input wire[31:0] address_bus
    input wire[31:0] data_from_cpu,
    input write_en,

    output  pulse;


);


reg[31:0] control_reg;

// reg[31:0] clock_cycles_counter;

reg[31:0] microseconds_counter , microseconds_counter_next;  // 27 cycles every microsecond
wire microseconds_tick = (microseconds_counter == (control_reg[15:0] - 1'b1));
wire pulse_signal = ((microseconds_counter <= (control_reg[15:0]) - 1'b1) && state == SEND_PULSE);
assign pulse = pulse_signal;

reg[31:0] miliseconds_counter , miliseconds_counter_next;  // 27000 cycles every milisecond
wire miliseconds_tick = (miliseconds_counter == (32'd540000 - 1'b1))

reg[4:0] state , next_state;
localparam[4:0]  IDLE = 4'b0000  , WAIT=4'b0001 , SEND_PULSE = 4'b0010 ;


always @() begin
    if(!rst)begin
        microseconds_counter <= 32'b0;
        miliseconds_counter <= 32'b0;
        state <= IDLE;
        
    end else begin
        if(enable)begin
            if(state == WAIT)begin
            miliseconds_counter <= (miliseconds_counter == (32'd540000 - 1'b1))?32'b0:miliseconds_counter_next;

        end

          if(state == SEND_PULSE)begin
            microseconds_counter <= (microseconds_counter >= (control_reg[15:0] - 1'b1))?32'b0:microseconds_counter_next;
            
        end

        if(write_en)begin
            control_reg <= data_from_cpu;
        end

        microseconds_counter <= microseconds_counter_next;
        miliseconds_counter <= miliseconds_counter_next;
        state <= next_state;

        end
    end
end

always @(*) begin
    pulse = 1'b0;
     next_state = ILE;
     miliseconds_counter_next = 1'b0;
     microseconds_counter_next = 1'b0;

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
              microseconds_counter_next = microseconds_counter = 1'b1
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