`timescale 1 ns / 1 ns

module tb_overlay;

    parameter FILE_PATH_I = "/home/hicksze1/antsdr-pynq/boards/e200/fm_radio/sim/iq_files/tb_chirp_I.hex";
    parameter FILE_PATH_Q = "/home/hicksze1/antsdr-pynq/boards/e200/fm_radio/sim/iq_files/tb_chirp_Q.hex";
    // parameter FILE_PATH_I = "/home/hicksze1/antsdr-pynq/boards/e200/fm_radio/sim/iq_files/tb_fm_I.hex";
    // parameter FILE_PATH_Q = "/home/hicksze1/antsdr-pynq/boards/e200/fm_radio/sim/iq_files/tb_fm_Q.hex";
    parameter CLK_PERIOD = 130; // ns
    parameter SAMPLE_CLK_PERIOD = 520; // ns

    reg clk;
    reg rst;
    reg in_valid;
    reg signed [15:0] in_I;
    reg signed [15:0] in_Q;

    // Generate clocks
    always begin : clk_gen
        clk <= 1'b1;
        # (CLK_PERIOD/2);
        clk <= 1'b0;
        # (CLK_PERIOD/2);
    end

    // Generate initial reset
    initial begin : reset_gen
        rst = 1;
        # (4*CLK_PERIOD);
        rst = 0;
    end

    // Read IQ values from file
    integer file_I, file_Q;
    integer hex_I, hex_Q;
    integer eof_I, eof_Q;

    initial begin : read_files
        // Open files
        file_I = $fopen(FILE_PATH_I, "r");
        file_Q = $fopen(FILE_PATH_Q, "r");

        if (file_I == 0 || file_Q == 0) begin
            $display("Error: Could not open IQ files");
            $finish;
        end

        // Read raw values from files
        while (! $feof(file_I)) begin
            eof_I = ($fscanf(file_I, "%h", hex_I));
            eof_Q = ($fscanf(file_Q, "%h", hex_Q));
        
            // Create input data signals
            assign in_I = hex_I[15:0];
            assign in_Q = hex_Q[15:0];

            // Strobe data valid
            in_valid = 1;
            # (CLK_PERIOD);
            in_valid = 0;
            # (SAMPLE_CLK_PERIOD - CLK_PERIOD);
        end

        $fclose(file_I);
        $fclose(file_Q);
    end

    wire [15:0] o_I0_data;
    wire [15:0] o_Q0_data;
    wire [15:0] o_I1_data;
    wire [15:0] o_Q1_data;
    wire o_I0_valid;
    wire o_Q0_valid;
    wire o_I1_valid;
    wire o_Q1_valid;


    overlay_top_wrapper uut_overlay (
        .i_rx_clk(clk),
        .i_rst(rst),
        .i_I0_data(in_I),
        .i_Q0_data(in_Q),
        .i_I1_data(in_I),
        .i_Q1_data(in_Q),
        .i_I0_valid(in_valid),
        .i_Q0_valid(in_valid),
        .i_I1_valid(in_valid),
        .i_Q1_valid(in_valid),
        .o_I0_data(o_I0_data),
        .o_Q0_data(o_Q0_data),
        .o_I1_data(o_I1_data),
        .o_Q1_data(o_Q1_data),
        .o_I0_valid(o_I0_valid),
        .o_Q0_valid(o_Q0_valid),
        .o_I1_valid(o_I1_valid),
        .o_Q1_valid(o_Q1_valid)
    );

endmodule  // tb_overlay