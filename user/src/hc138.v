`timescale 1ns/1ps
// 3-to-8 decoder (74HC138) - Each output gets slight delay
module hc138 (
    input  wire a2, a1, a0, input wire g1, input wire g2a_n, g2b_n,
    output wire y0_n, y1_n, y2_n, y3_n, y4_n, y5_n, y6_n, y7_n
);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    wire en = g1 & ~g2a_n & ~g2b_n;
    assign #`HC_TPD y0_n = ~(en & ~a2 & ~a1 & ~a0);
    assign #`HC_TPD y1_n = ~(en & ~a2 & ~a1 &  a0);
    assign #`HC_TPD y2_n = ~(en & ~a2 &  a1 & ~a0);
    assign #`HC_TPD y3_n = ~(en & ~a2 &  a1 &  a0);
    assign #`HC_TPD y4_n = ~(en &  a2 & ~a1 & ~a0);
    assign #`HC_TPD y5_n = ~(en &  a2 & ~a1 &  a0);
    assign #`HC_TPD y6_n = ~(en &  a2 &  a1 & ~a0);
    assign #`HC_TPD y7_n = ~(en &  a2 &  a1 &  a0);
endmodule