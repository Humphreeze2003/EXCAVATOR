module NRF_RECEIVER(
    input clk,
    input rst,

    input IRQ,

    input[31:0] data_from_cpu,
    // input[31:0] address_bus
    input write_en,
    input enable,
    output[31:0] data_to_cpu,
    input[31:0] offset

);


  // receives the IRQ signal from the nrf physical module

 reg[31:0] control_reg , control_reg_next;
 reg[31:0] status_reg , status_reg_next;

 reg irq_reg;
 assign data_to_cpu = (enable  && !write_en && offset == 0)?control_reg:(enable && !write_en && offset == 1)?status_reg:32'b0;

always @(posedge clk or negedge rst) begin
      if(!rst)begin
        control_reg <= 32'b0;
        status_reg <= 32'b0;

        irq_reg <= 1'b0;
      end else begin
    
     irq_reg <= IRQ;
       if(enable)begin
            if(write_en )begin  // writes are synchronous
            case (offset)
             0:begin
               control_reg <= data_from_cpu; 
             end

             1:begin
                status_reg <= data_from_cpu;
             end
                default: ;
            endcase
        end
// else 

//       end


       if(irq_reg == 1'b1 && !IRQ)begin   // read IRQ port by edge detection
         status_reg[0] <= 1'b1;  // will be set back to low by CPU
       end
       

      end
end
end
endmodule