`timescale 1ns/1ps
// Tri-state buffer (74HC125)
module hc125 (input a, input oe_n, inout y);
    `ifndef HC_TPD
    `define HC_TPD 0.001   // 1 ps: break zero-delay loops
    `endif
    // Add 1 ps inertial delay to Z release as well to avoid bus glitches
    assign #`HC_TPD y = (oe_n===1'b0) ? a : 1'bz;
endmodule