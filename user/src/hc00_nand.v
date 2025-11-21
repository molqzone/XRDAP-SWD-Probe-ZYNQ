`timescale 1ns/1ps
// 2-input NAND (74HC00)
module hc00_nand (input a, input b, output y);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    assign #`HC_TPD y = ~(a & b);
endmodule