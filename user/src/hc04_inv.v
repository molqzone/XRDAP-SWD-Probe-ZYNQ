`timescale 1ns/1ps
// Inverter (74HC04)
module hc04_inv  (input a, output y);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    assign #`HC_TPD y = ~a;
endmodule