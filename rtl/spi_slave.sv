// =====================================================================
// spi_slave.sv - SPI mode 0 slave, oversampled on sys clk
//
// Protocol (MSB first, CS active low):
//   byte 0 (MOSI) : {R/W_n, A[6:0]}   1 = read
//   byte 0 (MISO) : status_i          (free status poll every transaction)
//   byte 1..N     : data, address auto-increments
//
// Timing (f_clk = 100 MHz):
//   SCLK must satisfy  f_sclk <= f_clk/4  (each half period >= 2 clk)
//   MISO latency after SCLK fall = 4 clk + t_io  (~50 ns)
//     -> f_sclk <= 1/(2*t_lat) ~ 10 MHz without master-side compensation
//
// Register bus (sys clk domain):
//   addr_o      : current address
//   rd_en_o     : 1-clk pulse, rd_data_i (combinational reg[addr_o])
//                 is captured this cycle; addr increments after
//   wr_en_o     : 1-clk pulse, write wr_data_o to reg[addr_o];
//                 addr increments after
// =====================================================================
`default_nettype none

module spi_slave (
    input  wire        clk,
    input  wire        rst,

    // SPI pins (asynchronous)
    input  wire        spi_cs_n,
    input  wire        spi_sclk,
    input  wire        spi_mosi,
    output logic       miso_o,
    output logic       miso_oe,

    // Shifted out during the command byte
    input  wire  [7:0] status_i,

    // Register bus
    output logic [6:0] addr_o,
    output logic       rd_en_o,
    input  wire  [7:0] rd_data_i,
    output logic       wr_en_o,
    output logic [7:0] wr_data_o,
    output logic       busy_o
);

    // ---------------- Synchronizers + edge detect ----------------
    logic [2:0] cs_sr   = 3'b111;
    logic [2:0] sclk_sr = 3'b000;
    logic [1:0] mosi_sr = 2'b00;

    always_ff @(posedge clk) begin
        cs_sr   <= {cs_sr[1:0],   spi_cs_n};
        sclk_sr <= {sclk_sr[1:0], spi_sclk};
        mosi_sr <= {mosi_sr[0],   spi_mosi};
    end

    wire cs_active = ~cs_sr[1];
    wire sclk_rise =  sclk_sr[1] & ~sclk_sr[2];
    wire sclk_fall = ~sclk_sr[1] &  sclk_sr[2];
    wire mosi_bit  =  mosi_sr[1];          // aligned with sclk_sr[1]

    // ---------------- Frame state ----------------
    logic [2:0] bit_cnt;
    logic [6:0] rx_sr;
    logic [7:0] tx_sr;
    logic       is_cmd;     // next completed byte is the command byte
    logic       is_read;
    logic       load_pend;  // load tx_sr on the next clk
    logic [6:0] addr;

    wire [7:0] rx_byte = {rx_sr, mosi_bit};

    always_ff @(posedge clk) begin
        if (rst || !cs_active) begin
            bit_cnt   <= '0;
            rx_sr     <= '0;
            is_cmd    <= 1'b1;
            is_read   <= 1'b0;
            load_pend <= 1'b0;
            wr_en_o   <= 1'b0;
            tx_sr     <= status_i;         // valid on MISO as soon as CS falls
            if (rst) begin
                addr      <= '0;
                wr_data_o <= '0;
            end
        end else begin
            wr_en_o   <= 1'b0;
            load_pend <= 1'b0;

            // Prefetch: next MISO byte, 1 clk after the byte boundary
            if (load_pend) begin
                tx_sr <= is_read ? rd_data_i : 8'h00;
                if (is_read) addr <= addr + 1'b1;
            end

            // Write committed this cycle -> advance address
            if (wr_en_o) addr <= addr + 1'b1;

            if (sclk_rise) begin
                rx_sr   <= rx_byte[6:0];
                bit_cnt <= bit_cnt + 1'b1;

                if (bit_cnt == 3'd7) begin              // byte complete
                    is_cmd    <= 1'b0;
                    load_pend <= 1'b1;
                    if (is_cmd) begin
                        is_read <= rx_byte[7];
                        addr    <= rx_byte[6:0];
                    end else if (!is_read) begin
                        wr_en_o   <= 1'b1;
                        wr_data_o <= rx_byte;
                    end
                end
            end else if (sclk_fall && bit_cnt != 3'd0) begin
                // Shift within a byte; on the boundary fall (bit_cnt==0)
                // the freshly loaded byte's MSB is already in place.
                tx_sr <= {tx_sr[6:0], 1'b0};
            end
        end
    end

    assign addr_o  = addr;
    assign rd_en_o = load_pend & is_read;
    assign busy_o  = cs_active;

    // ---------------- MISO output register (pack into IOB) ----------------
    (* IOB = "TRUE" *) logic miso_q  = 1'b0;
    (* IOB = "TRUE" *) logic miso_oe_q = 1'b0;

    always_ff @(posedge clk) begin
        miso_q    <= tx_sr[7];
        miso_oe_q <= cs_active;
    end

    assign miso_o  = miso_q;
    assign miso_oe = miso_oe_q;

endmodule

`default_nettype wire