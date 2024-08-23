`timescale 1 ns / 1 ns

module tb_freq_demod;

    parameter FILE_PATH_I = "/home/hicksze1/antsdr-pynq/boards/e200/fm_radio/sim/iq_files/tb_chirp_I.hex";
    parameter FILE_PATH_Q = "/home/hicksze1/antsdr-pynq/boards/e200/fm_radio/sim/iq_files/tb_chirp_Q.hex";
    parameter CLK_PERIOD = 130; // ns
    parameter SAMPLE_CLK_PERIOD = 2604; // ns

    reg clk;
    reg reset_n;
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
    initial begin : reset
        reset_n = 0;
        # (CLK_PERIOD);
        reset_n = 1;
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

    wire [33:0] o_data;
    wire o_valid;
    

    freq_demod uut_freq_demod (
        .i_clk(clk),
        .i_rst(!reset_n),
        .i_I_data(in_I),
        .i_I_valid(in_valid),
        .i_Q_data(in_Q),
        .i_Q_valid(in_valid),
        .o_data(o_data),
        .o_valid(o_valid)
    );

endmodule  // tb_overlay