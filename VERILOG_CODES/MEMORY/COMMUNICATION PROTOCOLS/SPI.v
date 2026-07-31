module SPI (
    input clk,
    input rst,
    input wire[31:0] data_to_transmit,
    input offset,
    input write_en,
    input enable,

    input start_tx,
    input start_rx,


    output reg[31:0] data_received,
    output reg MOSI,
    output reg MISO,
    output reg SPI_CLK,
    output reg slave_select
   

);
    
 
    


    reg[31:0] control_reg;
    reg[31:0] status_reg;
    reg[31:0] slave_address_reg;

    reg[31:0] buffer_reg_0 , buffer_reg_0_next; // data to transmit
    reg[31:0] buffer_reg_1 , buffer_reg_1_next; // data to receive
    reg[31:0] buffer_reg_2 , buffer_reg_2_next;
    reg[31:0] buffer_reg_3 , buffer_reg_3_next;




wire[15:0] clock_period = control_reg[15:0] // period counter for the frequency 
wire[15:0] bytes_to_receive = control_reg[19:16];
wire[15:0] bytes_to_send = control_reg[23:20];

wire[31_0] bits_to_send = bytes_to_send * 5'd8;
wire[31:0] bits_to_receive = bytes_to_receive * 5'd8;


reg transmitting = status_reg[0];
reg receiving = status_reg[1];
reg done_transitting = status_reg[2];
reg done_receiving = status_reg[3];





reg[31:0] clock_cycles_counter  ,clock_cycles_counter_next;
reg enable_cycles_counter , enable_cycles_counter_next;
wire spi_clk_rise_tick ,spi_clk_rise_tick_next = (clock_cycles_counter <= (clock_period/2));
wire spi_clk_fall_tick ,spi_clk_fall_tick_next = (clock_cycles_counter > (clock_period/2));
wire spi_period_tick = (clock_cycles_counter == (clock_period) - 1);



           assign SPI_CLK = spi_clk_rise_tick;

reg[31:0] bits_counter , bits_counter_next;
reg[31:0] bytes_received , bytes_received_next;
reg[31:0] bytes_sent , bytes_sent_next;
// reg[31 , 0] bytes_sent , bytes_sent_next
wire[31_0] bits_to_send = bytes_to_send * 5'd8;
wire[31:0] bits_to_receive = bytes_to_receive * 5'd8;


localparam[4:0] IDLE = 5'b0 , 
                TRANSMIT = 5'd1 , 
                DONE_TRANSMITTING = 5'd2 , 
                RECEIVE = 5'd3,
                DONE_RECEIVING = 5'd4;


localparam[4:0] state , next_state;







always @(posedge clk or negedge rst) begin
      if(!rst)begin
         status_reg <= 32'b0;
         slave_address_reg <= 32'b0;

         buffer_reg_0 <= 32'b0;
         buffer_reg_1 <= 32'b0;
         buffer_reg_2 <= 32'b0;
         buffer_reg_3 <= 32'b0;

         clock_cycles_counter <= 32'b0;
         enable_cycles_counter <= 32'b0;
         
         bits_counter <= 32'b0
         bytes_received <= 32'b0;
         bytes_sent <= 32'b0;

         state <= IDLE;

      end else begin
         
        //  status_reg <= 32'b0;
        //  slave_address_reg <= 32'b0;

       if(enable)begin
           buffer_reg_0 <= buffer_reg_0_next;
         buffer_reg_1 <= buffer_reg_1_next;
         buffer_reg_2 <= buffer_reg_2_next;
         buffer_reg_3 <= buffer_reg_3_next;

         clock_cycles_counter <= clock_cycles_counter_next;
         enable_cycles_counter <= enable_cycles_counter_next;
         bits_counter <= bits_counter_next;
        //  bytes_received <= bytes_received_next;
        //  bytes_sent <= bytes_sent_next;

         state <= next_state;

         if(enable_cycles_counter)begin
            clock_cycles_counter <= (clock_cycles_counter == (clock_period - 1'b1))32'b0:clock_cycles_counter_next;
         end
       end

      end
end

always @(*) begin
    clock_cycles_counter_next = 1'b0;
    next_state = IDLE;
    enable_cycles_counter_next = 1'b0;
    MOSI = 1'b0;
    MISO = 1'b0;

    buffer_reg_0_next = buffer_reg_0;
    buffer_reg_1_next = buffer_reg_1;
    buffer_reg_2_next = buffer_reg_2;
    buffer_reg_3_next = buffer_reg_3;
    
    bits_counter_next = 32'b0;

    transmit = 1'b0;
    receiving = 1'b0;
    done_receiving = 1'b0;
    done_transitting = 1'b0;

    case (state)

        IDLE:begin
            if(start_tx && enable)begin
                next_state = TRANSMIT; 
            end 

            if(start_rx && enable)begin
                next_state = RECEIVE;
            end
            next_state = IDLE;
        end


        TRANSMIT : begin
            transmitting = 1'b1;
            enable_cycles_counter_next = 1'b1;
            clock_cycles_counter_next = clock_cycles_counter_next + 1'b1;
           
           if(spi_clk_rise_tick)begin
            MOSI = buffer_reg_0[0];  // transmit
           end

           if(spi_clk_fall_tick)begin
            buffer_reg_0_next = {1'b0 , buffer_reg_0[7:1]} // change data
            if(bits_counter < bits_to_send)begin
                bits_counter_next= bytes_sent + 1'b1;
                next_state = TRANSMIT;
            end else begin
                 bits_counter_next = 32'b0;
                 next_state = DONE_TRANSMITTING;
            end
           end




        end



           RECEIVE : begin
           receiving = 1'b1;
           enable_cycles_counter_next = 1'b1;
           clock_cycles_counter_next = clock_cycles_counter_next + 1'b1;
           
           if(spi_clk_rise_tick)begin

            buffer_reg_1_next = {buffer_reg_1[6:0] , MISO};  // receive
           end

           if(spi_clk_fall_tick)begin
            // buffer_reg_0_next = {1'b0 , buffer_reg_0[7:1]} // change data
            if(bits_counter < bits_to_receive)begin
                bits_counter_next = bits_counter + 1'b1;
                next_state = RECEIVE;
            end else begin
                 bits_counter_next = 32'b0;
                 next_state = DONE_RECEIVING;
            end
           end




        end


        DONE_TRANSMITTING:begin
            done_transitting = 1'b1;
            next_state = IDLE;
        end

        DONE_RECEIVING : begin
            next_state = IDLE;
        end





        default: 
    endcase
end
endmodule