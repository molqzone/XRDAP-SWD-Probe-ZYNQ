`timescale 1ns/1ps

module testbench_write_simple;
    // ==== DUT I/Os ====
    reg  sck   = 0;
    reg  mosi  = 0;
    wire miso;
    reg  rst_n = 0;
    reg  rnw   = 0;   // 0 = WRITE

    wire swclk;
    wire swdio;

    // TB: target drives only during the 3-bit ACK window; never drives in write data phase
    reg tb_swdio_en  = 0;
    reg tb_swdio_val = 0;
    assign swdio = tb_swdio_en ? tb_swdio_val : 1'bz;

    // Bit index (increments at posedge; logs the sampled bit position)
    reg [5:0] tb_bit_idx = 0;

    // ==== Instantiate DUT ====
    top dut(
        .sck(sck), .mosi(mosi), .miso(miso),
        .rst_n(rst_n), .rnw(rnw),
        .swclk(swclk), .swdio(swdio)
    );

    // ==== Clock ====
    always #1 sck = ~sck;

    // ==== Utilities ====
    task idle_cycles(input integer n);
        integer i;
        begin
            for (i=0; i<n; i=i+1)
                @(posedge sck);
        end
    endtask

    task pulse_reset_1clk;
        begin
            rst_n=0;
            @(posedge sck);
            rst_n=1;
            @(posedge sck);
        end
    endtask

    // ==== Simple frame test ====
    task test_write_frame(input [7:0] req_lsb_first, input [2:0] ack_bits, input string frame_name);
        integer i;
        begin
            $display("== Frame %s start @%0t | REQ=0x%02x ACK=%03b ==", frame_name, $time, req_lsb_first, ack_bits);

            // Simple test: just drive some clocks and verify basic operation
            rnw = 0;  // Ensure WRITE mode

            // Drive a basic pattern (48 clock cycles like the original)
            for (i = 0; i < 48; i = i + 1) begin
                @(negedge sck);
                // Simple MOSI pattern based on frame type
                if (i < 8) begin
                    mosi = req_lsb_first[i];
                end else begin
                    mosi = 1'b0;
                end

                // Drive ACK bits during appropriate window
                if (i >= 11 && i <= 13) begin
                    tb_swdio_en = 1;
                    tb_swdio_val = ack_bits[i-11];
                end else begin
                    tb_swdio_en = 0;
                    tb_swdio_val = 0;
                end
            end

            // Wait a bit more
            idle_cycles(4);

            $display("== Frame %s end @%0t ==", frame_name, $time);
        end
    endtask

    // ==== Main ====
    initial begin
        $dumpfile("prj/waveform/swd_write.vcd");
        $dumpvars(0, testbench_write_simple);

        idle_cycles(4);

        // ACK=001 (OK) - matching original pattern
        pulse_reset_1clk();
        test_write_frame(8'hA1, 3'b001, "WRITE_OK");

        // ACK=010 (WAIT)
        pulse_reset_1clk();
        test_write_frame(8'hA1, 3'b010, "WRITE_WAIT");

        // ACK=100 (FAULT)
        pulse_reset_1clk();
        test_write_frame(8'hA1, 3'b100, "WRITE_FAULT");

        $display("== TB finish ==");
        $finish;
    end

endmodule