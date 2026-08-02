module SPI (
    input clk,
    input rst,
    input wire[31:0] data_to_transmit,
    input offset,
    input write_en,
    input enable,

    // input start_tx,  --put in control reg
    // input start_rx, --- --put in control reg


    // output reg[31:0] data_received,  -- handled by firmware
    output reg MOSI,
    output reg MISO,
    output reg SPI_CLK,
    output reg slave_select
   

);
    
 
    


    reg[31:0] control_reg , control_reg_next;
    reg[31:0] status_reg , status_reg_next;
    // reg[31:0] slave_address_reg;

    reg[31:0] buffer_reg_0 , buffer_reg_0_next; // data to transmit
    reg[31:0] buffer_reg_1 , buffer_reg_1_next; // received data
    reg[31:0] buffer_reg_2 , buffer_reg_2_next;
    reg[31:0] buffer_reg_3 , buffer_reg_3_next;




wire[15:0] clock_period = control_reg[15:0] // period counter for the frequency 
wire[3:0] bytes_to_receive = control_reg[19:16];
wire[3:0] bytes_to_send = control_reg[23:20];
// reg start_tx = control_reg[24];
// reg start_rx = control_reg[25];
wire[31:0] bits_to_send = (bytes_to_send << 3 );
wire[31:0] bits_to_receive = (bytes_to_receive  << 3);








reg[31:0] clock_cycles_counter  ,clock_cycles_counter_next;
reg enable_cycles_counter , enable_cycles_counter_next;
wire spi_clk_rise_tick ,spi_clk_rise_tick_next = (clock_cycles_counter <= (clock_period/2));
wire spi_clk_fall_tick ,spi_clk_fall_tick_next = (clock_cycles_counter > (clock_period/2));
wire spi_period_tick = (clock_cycles_counter == (clock_period) - 1);



           assign SPI_CLK = spi_clk_rise_tick;




reg[31:0] bytes_received , bytes_received_next;
reg[31:0] bytes_sent , bytes_sent_next;
// reg[31 , 0] bytes_sent , bytes_sent_next

reg[31:0]  bits_counter , bits_counter_next;
wire[31_0] bits_to_send = bytes_to_send * 5'd8;
wire[31:0] bits_to_receive = bytes_to_receive * 5'd8;


localparam[4:0] IDLE = 5'b0 , 
                TRANSMIT = 5'd1 , 
                DONE_TRANSMITTING = 5'd2 , 
                RECEIVE = 5'd3,
                DONE_RECEIVING = 5'd4;


localparam[4:0] state , next_state;




always @(*) begin
     MOSI = 1'b0;
     MISO = 1'b0;
     spi_clk_rise_tick_next = 1'b0;
     slave_select = 1'b1;


     control_reg_next = control_reg;
     status_reg_next = status_reg;
     buffer_reg_0_next = buffer_reg_0;
     buffer_reg_1_next = buffer_reg_1;
     buffer_reg_2_next = buffer_reg_2;
     buffer_reg_3_next = buffer_reg_3;
end




endmodule