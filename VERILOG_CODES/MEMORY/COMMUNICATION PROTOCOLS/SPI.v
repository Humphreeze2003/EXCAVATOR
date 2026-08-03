module SPI (
    input clk,
    input rst,
    // input wire[31:0] data_to_transmit,
    input offset,
    input write_en,
    input enable,

    // input start_tx,  --put in control reg
    // input start_rx, --- --put in control reg


    // output reg[31:0] data_received,  -- handled by firmware
    output reg MOSI,
    input  MISO,
    output SPI_CLK,
    output reg slave_select,



    input[31:0] data_from_cpu,
    // input[31:0] address_bus
    input write_en,
    // input enable,
    output[31:0] data_to_cpu,
    input[31:0] offset
);
    
 
    

assign data_to_cpu = (enable && !write_en && offset ==0)?control_reg : (enable && !write_en && offset == 1)?status_reg:(enable && !write_en && offset == 2)?buffer_reg_0:(enable && !write_en && offset == 3)?buffer_reg_1:32'b0;

    reg[31:0] control_reg , control_reg_next;
    reg[31:0] status_reg , status_reg_next;
    // reg[31:0] slave_address_reg;

    reg[31:0] buffer_reg_0 , buffer_reg_0_next; // data to transmit
    reg[31:0] buffer_reg_1 , buffer_reg_1_next; // received data
    reg[31:0] buffer_reg_2 , buffer_reg_2_next;
    reg[31:0] buffer_reg_3 , buffer_reg_3_next;




wire[15:0] clock_period = control_reg[15:0] // period counter for the frequency 
wire[3:0] bytes_to_send = control_reg[19:16];
wire[3:0] bytes_to_receive = control_reg[23:20];
// wire start_tx = control_reg[24];
// wire start_rx = control_reg[25];
wire[31:0] bits_to_send = (bytes_to_send << 3 );
wire[31:0] bits_to_receive = (bytes_to_receive  << 3);








reg[31:0] clock_cycles_counter  ,clock_cycles_counter_next;
reg enable_cycles_counter , enable_cycles_counter_next;
wire spi_clk_rise_tick ,spi_clk_rise_tick_next = (clock_cycles_counter <= (clock_period/2));
wire spi_clk_fall_tick ,spi_clk_fall_tick_next = (clock_cycles_counter > (clock_period/2));
wire spi_period_tick = (clock_cycles_counter == (clock_period) - 1);



           assign SPI_CLK = spi_clk_rise_tick;




// reg[31:0] bytes_received , bytes_received_next;
// reg[31:0] bytes_sent , bytes_sent_next;
// reg[31 , 0] bytes_sent , bytes_sent_next

reg[31:0]  bits_counter , bits_counter_next;  // counts bits sent or received
// wire[31_0] bits_to_send = bytes_to_send * 5'd8;
// wire[31:0] bits_to_receive = bytes_to_receive * 5'd8;


localparam[4:0] IDLE = 5'b0 , 
                TRANSMIT = 5'd1 , 
                DONE_TRANSMITTING = 5'd2 , 
                RECEIVE = 5'd3,
                DONE_RECEIVING = 5'd4;




reg[4:0] state , next_state;





always @(posedge clk or negedge rst) begin
     if(!rst)begin
        MOSI <= 1'b0;
        slave_select <= 1'b1;

        control_reg <= 32'b0;
        status_reg <= 32'b0;

        buffer_reg_0 <= 32'b0;
        buffer_reg_1 <= 32'b0;
        buffer_reg_2 <= 32'b0;
        buffer_reg_3 <= 32'b0;
         
        clock_cycles_counter <= 32'b0;
        enable_cycles_counter <= 32'b0;
        bits_counter <= 32'b0;

        next_state <= 5'b0;

     end  else begin
        
        control_reg <= control_reg_next;
        status_reg <= status_reg_next;

        buffer_reg_0 <= buffer_reg_0_next;
        buffer_reg_1 <= buffer_reg_1_next;
        buffer_reg_2 <= buffer_reg_2_next;
        buffer_reg_3 <= buffer_reg_3_next;

        enable_cycles_counter <= enable_cycles_counter_next;
        clock_cycles_counter <= clock_cycles_counter_next;

        if(enable_cycles_counter)begin
              clock_cycles_counter_next <= (clock_cycles_counter == (clock_period - 1'b1))?32'b0:clock_cycles_counter_next;
        end

        // if(state == TRANSMIT)begin
        //     control_reg[24] <= 1'b0;
        //     status_reg[0] <= 1'b1;
        // end  else if(state == DONE_TRANSMITTING)begin
        //     status_reg[0] <= 1'b0;
        // end else if(state == RECEIVE)begin
        //     control_reg[25] <= 1'b0;
        //     status_reg[1] <= 1'b1;
        // end else if(stae == DONE_RECEIVING)begin
        //     status_reg[1] <= 1'b0;
        // end

        state <= next_state;

        if(write_en)begin
          case (offset)
            0: control_reg <= data_from_cpu;
            1: status_reg <= data_from_cpu;
            2: buffer_reg_0 <= data_from_cpu;
            3: buffer_reg_1 <= data_from_cpu;
            default: 
          endcase
        end
     end
end




always @(*) begin
     MOSI = 1'b0;
    //  MISO = 1'b0;
     spi_clk_rise_tick_next = 1'b0;
     slave_select = 1'b1;


     control_reg_next = control_reg;
     status_reg_next = status_reg;

     buffer_reg_0_next = buffer_reg_0;
     buffer_reg_1_next = buffer_reg_1;
     buffer_reg_2_next = buffer_reg_2;
     buffer_reg_3_next = buffer_reg_3;

     clock_cycles_counter_next = clock_cycles_counter;
     enable_cycles_counter_next = enable_cycles_counter;
     
     bytes_received_next = bytes_received;
     bytes_sent_next = bytes_sent;

     bits_counter_next = bits_counter;

     next_state = state;


   


    case (state)

        IDLE:begin
            if(control_reg[24])begin// start_tx
                next_state = TRANSMIT;
            end else if(control_reg[25])begin // start rx
                next_state = RECEIVE;
            end else begin
                next_state = IDLE;
            end

        end


      TRANSMIT:begin
         // write control_reg[24] back to 0;
         control_reg_next[24] = 'b0;
         // set status_reg[0] to 1
         status_reg_next[0] = 1'b1;
         enable_cycles_counter_next = 1'b1;
         slave_select = 1'b0;
         if(spi_clk_rise_tick)begin
            MOSI = buffer_reg_0[0];

         end else if(spi_clk_fall_tick)begin
            buffer_reg_0_next = {1'b0 , buffer_reg_0[31:1]};

         end else if(spi_period_tick)begin
              if(bits_counter < bits_to_send - 1'b1)begin
                next_state = TRANSMIT;
                bits_counter_next = bits_counter + 1'b1;
              end else begin
                next_state = DONE_TRANSMITTING;
                bits_counter_next = 32'b0;
              end
         end
      end




      DONE_TRANSMITTING:begin
          // set status_reg[0] to 0
          status_reg_next[0] = 1'b0;
          next_state = IDLE;
      end



      RECEIVE : begin
       // write control_reg[25] back to 0;
        control_reg_next[25] = 1'b0;
         // set status_reg[1] to 1
        status_reg_next[1] = 1'b1;
         enable_cycles_counter_next = 1'b1;
         slave_select = 1'b0;

         if(spi_clk_rise_tick)begin
            buffer_reg_1_next = {buffer_reg_1[30:0] , MISO};

         end else if(spi_clk_fall_tick)begin
            // buffer_reg_0_next = {1'b0 , buffer_reg_0[7:1]};

         end else if(spi_period_tick)begin
              if(bits_counter < bits_to_receive - 1'b1)begin
                next_state = RECEIVE;
                bits_counter_next = bits_counter + 1'b1;
              end else begin
                next_state = DONE_RECEIVING;
                bits_counter_next = 32'b0;
              end
         end
      end



      
       DONE_RECEIVING:begin
          // set status_reg[1] to 0
           status_reg_next[1] = 1'b0;
          next_state = IDLE;
      end





        default:   next_state = IDLE;
    endcase

end




endmodule