`timescale 1ns/1ps
// 4-input NAND (74HC20)
module hc20_nand4(input a, input b, input c, input d, output y);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    assign #`HC_TPD y = ~(a & b & c & d);
endmodule