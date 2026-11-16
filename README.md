# FPGA SPI MMIO Expander (Basys-3)

> 🚧 **Work in progress**

Turns a **Digilent Basys-3 (Artix-7)** board into a memory-mapped I/O expander for a microcontroller. A host MCU (ESP32-C3) talks to the FPGA over **SPI** and reads/writes a register bank that controls **24 GPIOs, 16 LEDs, 16 switches and 5 buttons**, effectively giving a small microcontroller a large set of extra peripherals.

```
 ┌──────────┐    SPI (mode 0)     ┌─────────────────────────────┐
 │ ESP32-C3 │ ──CS/SCLK/MOSI────► │ spi_slave ─► register bank  │──► GPIO[23:0] (Pmod JB/JC/JXADC)
 │  (host)  │ ◄──────MISO──────── │                             │──► LED[15:0]
 │          │ ◄──────IRQ───────── │                             │◄── SW[15:0], BTN[4:0]
 └──────────┘                     └─────────────────────────────┘
                                       Basys-3 / Artix-7 @ 100 MHz
```

## Status

| Step | Description | Status |
|---|---|---|
| 1 | Pin plan + constraints (`Basys3_mmio.xdc`) | ✅ |
| 2 | Top-level ports + pin-mapping smoke test (LED = SW, heartbeat on LED15) | ✅ |
| 3 | SPI slave (`spi_slave.sv`) | ✅ written, integration pending |
| 4 | Register bank + GPIO direction/output/input registers + IRQ | ⏳ |
| 5 | ESP32-C3 driver | ⏳ |

## SPI protocol

SPI mode 0, MSB first, CS active low.

| Byte | MOSI | MISO |
|---|---|---|
| 0 | `{R/W_n, A[6:0]}` (1 = read) | `status` (a free status poll on every transaction) |
| 1..N | write data | read data |

The address **auto-increments** after each data byte, so burst reads and writes are supported.

## Design notes

**`spi_slave.sv`**
- SCLK, CS and MOSI are **oversampled** on the 100 MHz system clock through synchronizer shift registers with edge detection, so there is a single clock domain and no CDC issues.
- Requirement: `f_SCLK ≤ f_clk / 4`. MISO latency after the SCLK falling edge is about 4 clk + t_IO (≈ 50 ns), which gives `f_SCLK ≲ 10 MHz` without master-side compensation.
- The next read byte is **prefetched** one clock after each byte boundary.
- The MISO and output-enable flops use `(* IOB = "TRUE" *)` so they are packed into the I/O blocks for predictable output timing.
- Register bus: `addr_o`, 1-clock `rd_en_o` / `wr_en_o` pulses, and `busy_o` (CS active).

**`top.sv`**
- Power-on reset counter + **2-flop synchronized** external reset (`ext_rst_n`, async → sync, active-high internal reset).
- Uses `` `default_nettype none `` to catch implicit nets.

## Pin map (Basys-3)

| Signal | Location |
|---|---|
| SPI CS / MOSI / MISO / SCLK, IRQ, ext reset | Pmod **JA** |
| `gpio[7:0]` | Pmod **JB** |
| `gpio[15:8]` | Pmod **JC** |
| `gpio[23:16]` | Pmod **JXADC** |
| `led[15:0]`, `sw[15:0]`, `btn[4:0]` | On-board |

See [`constraints/Basys3_mmio.xdc`](constraints/Basys3_mmio.xdc) for exact pins.

## Build

1. Create a Vivado project for `xc7a35tcpg236-1` (Basys-3)
2. Add `rtl/*.sv` as design sources and `constraints/Basys3_mmio.xdc` as constraints
3. Set `top` as the top module, then run synthesis → implementation → bitstream

## Author

**Bahittin Can Acar**
