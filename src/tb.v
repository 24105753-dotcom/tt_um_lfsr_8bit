`timescale 1ns/1ps

module tb;
    reg        clk;
    reg        rst_n;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_lfsr_8bit dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(1'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    integer i;
    reg [7:0] seed_check;

    initial begin
        // Ghi file dạng sóng GTKWave
        $dumpfile("lfsr_waveform.vcd");
        $dumpvars(0, tb);

        clk = 0; rst_n = 0; ui_in = 8'h00; uio_in = 8'h00;
        #20 rst_n = 1; #10;

        // --- CA 1: Nạp Seed 8'hA5 & Chạy đủ 255 bước ---
        $display("=== CA 1: KIEM TRA CHU KY 255 BUOC ===");
        seed_check = 8'hA5;
        ui_in = seed_check;
        uio_in[0] = 1'b1; #10; // load_seed = 1
        uio_in[0] = 1'b0; uio_in[1] = 1'b1; // enable = 1

        for (i = 1; i <= 255; i = i + 1) begin
            #10;
            if (i < 255 && uo_out == seed_check)
                $display("[LOI] Lap chu ky thap tai buoc %0d!", i);
        end

        if (uo_out == seed_check)
            $display("[XAC NHAN] XUAT SAC! Dung 255 buoc quay lai Seed 8'hA5.");

        // --- CA 2: Thoát Hố đen (8'h00) ---
        $display("\n=== CA 2: KIEM TRA HO DEN (8'h00) ===");
        ui_in = 8'h00; uio_in[0] = 1'b1; #10;
        uio_in[0] = 1'b0; #10;
        if (uo_out != 8'h00)
            $display("[XAC NHAN] MACH DA THOAT HO DEN! Gia tri: 8'h%h", uo_out);

        $finish;
    end
endmodule
