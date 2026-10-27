module tt_um_lfsr_8bit (
    input  wire [7:0] ui_in,    // Hạt giống ban đầu (Seed)
    output wire [7:0] uo_out,   // Trạng thái LFSR đầu ra
    input  wire [7:0] uio_in,   // uio_in[0]: load_seed, uio_in[1]: enable
    output wire [7:0] uio_out,  // Gán 0 (không dùng làm output)
    output wire [7:0] uio_oe,   // Gán 0 (tất cả chân uio_in làm Input)
    input  wire       ena,      // Tiny Tapeout enable
    input  wire       clk,      // Xung clock
    input  wire       rst_n     // Reset tích cực mức thấp
);

    // Giải mã tín hiệu từ chân uio_in
    wire load_seed = uio_in[0];
    wire enable    = uio_in[1];

    reg [7:0] lfsr_reg;

    // Đa thức chu kỳ cực đại 255: x^8 + x^6 + x^5 + x^4 + 1
    // Lấy XOR phản hồi từ các bit 7, 5, 4, 3 (tương ứng với x^8, x^6, x^5, x^4)
    wire feedback_bit = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3];

    // Mạch bảo vệ Hố đen (8'h00): Nếu lfsr_reg = 0 thì ép bit phản hồi thành 1 để thoát
    wire safe_feedback = (lfsr_reg == 8'h00) ? 1'b1 : feedback_bit;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr_reg <= 8'h01; // Seed mặc định khi rst_n = 0
        end else if (load_seed) begin
            // Nạp seed từ ui_in; nếu cố tình nạp 8'h00 thì tự chuyển về 8'h01
            lfsr_reg <= (ui_in == 8'h00) ? 8'h01 : ui_in;
        end else if (enable) begin
            // Dịch bit sang trái và đưa bit phản hồi vào LSB
            lfsr_reg <= {lfsr_reg[6:0], safe_feedback};
        end
    end

    // Gán tín hiệu đầu ra
    assign uo_out  = lfsr_reg;
    assign uio_out = 8'b0000_0000;
    assign uio_oe  = 8'b0000_0000;

endmodule
