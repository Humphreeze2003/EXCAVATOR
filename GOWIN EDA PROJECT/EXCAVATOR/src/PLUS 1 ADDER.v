module PLUS_1(
    input wire[31:0] val,

    output reg[31:0] plus_1
);


always @(*) begin
    plus_1 = val + 1'b1;
end

endmodule 