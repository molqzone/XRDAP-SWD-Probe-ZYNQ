`timescale 1ns/1ps
// Synchronous counter (74HC163) - Add 1 ps from clock to Q (for simulation stability only, doesn't affect bit boundaries)
module hc163 (input wire clk, input wire clr_n, input wire en, output wire [3:0] q);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    reg [3:0] cnt;
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n)       cnt <= #`HC_TPD 4'd0;
        else if (en)      cnt <= #`HC_TPD (cnt + 4'd1);
        // Keep original value when not enabled
    end
    assign q = cnt;
endmodule