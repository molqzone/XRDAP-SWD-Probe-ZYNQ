`timescale 1ns/1ps
// 3-input NAND (74HC10)
module hc10_nand3(input a, input b, input c, output y);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    assign #`HC_TPD y = ~(a & b & c);
endmodule