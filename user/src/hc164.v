`timescale 1ns/1ps
// Serial-in parallel-out shift register (74HC164) - Add 1 ps from clk to Q
module hc164 (input wire clk, input wire clr_n, input wire d_in, output wire [7:0] q);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    reg [7:0] sh;
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) sh <= #`HC_TPD 8'h00;
        else        sh <= #`HC_TPD {sh[6:0], d_in};
    end
    assign q = sh;
endmodule