// =====================================================================
// top.sv - Basys-3 MMIO expander, top level
//
// STEP 2 PLACEHOLDER: ports are final, logic is a pin-mapping smoke test.
//   led       = sw           (checks LED + switch constraints)
//   led[15]   = heartbeat    (checks clock, ~1.5 Hz blink) when sw[15]=0
//   gpio, miso: high-Z       (safe: nothing driven on Pmods)
// SPI slave + register bank replace this in steps 3-4.
// =====================================================================
`default_nettype none

module top (
    input  wire        clk,        // 100 MHz

    // SPI link to ESP32-C3 (Pmod JA)
    input  wire        spi_cs_n,
    input  wire        spi_sclk,
    input  wire        spi_mosi,
    output wire        spi_miso,
    output wire        irq,
    input  wire        ext_rst_n,  // optional soft reset, pulled up

    // Expanded resources
    inout  wire [23:0] gpio,       // JB=[7:0] JC=[15:8] JXADC=[23:16]
    output wire [15:0] led,
    input  wire [15:0] sw,
    input  wire [4:0]  btn         // {D,R,L,U,C}
);

    // ---------------- Reset: power-on + external ----------------
    // POR: FPGA flops init to 0 after configuration; hold reset 16 clks.
    logic [3:0] por_cnt = '0;
    logic       rst_sync1 = 1'b1, rst_sync2 = 1'b1;
    wire        por_done = &por_cnt;

    always_ff @(posedge clk) begin
        if (!por_done) por_cnt <= por_cnt + 1'b1;
        rst_sync1 <= !por_done || !ext_rst_n;   // ext_rst_n is async -> sync
        rst_sync2 <= rst_sync1;
    end
    wire rst = rst_sync2;                       // active-high, synchronous

    // ---------------- Smoke test logic ----------------
    logic [25:0] hb_cnt;
    always_ff @(posedge clk) begin
        if (rst) hb_cnt <= '0;
        else     hb_cnt <= hb_cnt + 1'b1;
    end

    assign led[14:0] = sw[14:0];
    assign led[15]   = sw[15] | hb_cnt[25];     // blink unless sw15 forces on

    assign gpio      = 'z;
    assign spi_miso  = 1'bz;
    assign irq       = 1'b0;

    // Unused-input sink (keeps lint quiet, optimized away)
    wire unused = &{1'b0, spi_cs_n, spi_sclk, spi_mosi, btn, gpio};

endmodule

`default_nettype wire