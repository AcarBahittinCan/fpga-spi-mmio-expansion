## =====================================================================
## basys3_mmio.xdc  -  Basys-3 (xc7a35tcpg236-1) MMIO expander
## Pin locations from Digilent Basys-3 master XDC.
## =====================================================================

## ---------------- Clock (100 MHz) ----------------
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -name sys_clk -period 10.000 -waveform {0 5} [get_ports clk]

## ---------------- SPI link to ESP32-C3 (Pmod JA, top row) ----------------
## JA1=CS  JA2=MOSI  JA3=MISO  JA4=SCLK  JA7=IRQ  JA8=ext reset (optional)
set_property -dict { PACKAGE_PIN J1   IOSTANDARD LVCMOS33 PULLUP true } [get_ports spi_cs_n]
set_property -dict { PACKAGE_PIN L2   IOSTANDARD LVCMOS33 }             [get_ports spi_mosi]
set_property -dict { PACKAGE_PIN J2   IOSTANDARD LVCMOS33 DRIVE 8 SLEW FAST } [get_ports spi_miso]
set_property -dict { PACKAGE_PIN G2   IOSTANDARD LVCMOS33 }             [get_ports spi_sclk]
set_property -dict { PACKAGE_PIN H1   IOSTANDARD LVCMOS33 DRIVE 8 }     [get_ports irq]
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 PULLUP true } [get_ports ext_rst_n]
## JA9 (H2), JA10 (G3) spare

## ---------------- Expanded GPIO: gpio[23:0] ----------------
## gpio[7:0]   = Pmod JB
set_property -dict { PACKAGE_PIN A14  IOSTANDARD LVCMOS33 } [get_ports {gpio[0]}]
set_property -dict { PACKAGE_PIN A16  IOSTANDARD LVCMOS33 } [get_ports {gpio[1]}]
set_property -dict { PACKAGE_PIN B15  IOSTANDARD LVCMOS33 } [get_ports {gpio[2]}]
set_property -dict { PACKAGE_PIN B16  IOSTANDARD LVCMOS33 } [get_ports {gpio[3]}]
set_property -dict { PACKAGE_PIN A15  IOSTANDARD LVCMOS33 } [get_ports {gpio[4]}]
set_property -dict { PACKAGE_PIN A17  IOSTANDARD LVCMOS33 } [get_ports {gpio[5]}]
set_property -dict { PACKAGE_PIN C15  IOSTANDARD LVCMOS33 } [get_ports {gpio[6]}]
set_property -dict { PACKAGE_PIN C16  IOSTANDARD LVCMOS33 } [get_ports {gpio[7]}]
## gpio[15:8]  = Pmod JC
set_property -dict { PACKAGE_PIN K17  IOSTANDARD LVCMOS33 } [get_ports {gpio[8]}]
set_property -dict { PACKAGE_PIN M18  IOSTANDARD LVCMOS33 } [get_ports {gpio[9]}]
set_property -dict { PACKAGE_PIN N17  IOSTANDARD LVCMOS33 } [get_ports {gpio[10]}]
set_property -dict { PACKAGE_PIN P18  IOSTANDARD LVCMOS33 } [get_ports {gpio[11]}]
set_property -dict { PACKAGE_PIN L17  IOSTANDARD LVCMOS33 } [get_ports {gpio[12]}]
set_property -dict { PACKAGE_PIN M19  IOSTANDARD LVCMOS33 } [get_ports {gpio[13]}]
set_property -dict { PACKAGE_PIN P17  IOSTANDARD LVCMOS33 } [get_ports {gpio[14]}]
set_property -dict { PACKAGE_PIN R18  IOSTANDARD LVCMOS33 } [get_ports {gpio[15]}]
## gpio[23:16] = Pmod JXADC (used as plain digital I/O)
set_property -dict { PACKAGE_PIN J3   IOSTANDARD LVCMOS33 } [get_ports {gpio[16]}]
set_property -dict { PACKAGE_PIN L3   IOSTANDARD LVCMOS33 } [get_ports {gpio[17]}]
set_property -dict { PACKAGE_PIN M2   IOSTANDARD LVCMOS33 } [get_ports {gpio[18]}]
set_property -dict { PACKAGE_PIN N2   IOSTANDARD LVCMOS33 } [get_ports {gpio[19]}]
set_property -dict { PACKAGE_PIN K3   IOSTANDARD LVCMOS33 } [get_ports {gpio[20]}]
set_property -dict { PACKAGE_PIN M3   IOSTANDARD LVCMOS33 } [get_ports {gpio[21]}]
set_property -dict { PACKAGE_PIN M1   IOSTANDARD LVCMOS33 } [get_ports {gpio[22]}]
set_property -dict { PACKAGE_PIN N1   IOSTANDARD LVCMOS33 } [get_ports {gpio[23]}]

## ---------------- LEDs ----------------
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN U19  IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN V19  IOSTANDARD LVCMOS33 } [get_ports {led[3]}]
set_property -dict { PACKAGE_PIN W18  IOSTANDARD LVCMOS33 } [get_ports {led[4]}]
set_property -dict { PACKAGE_PIN U15  IOSTANDARD LVCMOS33 } [get_ports {led[5]}]
set_property -dict { PACKAGE_PIN U14  IOSTANDARD LVCMOS33 } [get_ports {led[6]}]
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33 } [get_ports {led[7]}]
set_property -dict { PACKAGE_PIN V13  IOSTANDARD LVCMOS33 } [get_ports {led[8]}]
set_property -dict { PACKAGE_PIN V3   IOSTANDARD LVCMOS33 } [get_ports {led[9]}]
set_property -dict { PACKAGE_PIN W3   IOSTANDARD LVCMOS33 } [get_ports {led[10]}]
set_property -dict { PACKAGE_PIN U3   IOSTANDARD LVCMOS33 } [get_ports {led[11]}]
set_property -dict { PACKAGE_PIN P3   IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
set_property -dict { PACKAGE_PIN N3   IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
set_property -dict { PACKAGE_PIN P1   IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
set_property -dict { PACKAGE_PIN L1   IOSTANDARD LVCMOS33 } [get_ports {led[15]}]

## ---------------- Switches ----------------
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {sw[0]}]
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports {sw[1]}]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports {sw[2]}]
set_property -dict { PACKAGE_PIN W17  IOSTANDARD LVCMOS33 } [get_ports {sw[3]}]
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33 } [get_ports {sw[4]}]
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports {sw[5]}]
set_property -dict { PACKAGE_PIN W14  IOSTANDARD LVCMOS33 } [get_ports {sw[6]}]
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33 } [get_ports {sw[7]}]
set_property -dict { PACKAGE_PIN V2   IOSTANDARD LVCMOS33 } [get_ports {sw[8]}]
set_property -dict { PACKAGE_PIN T3   IOSTANDARD LVCMOS33 } [get_ports {sw[9]}]
set_property -dict { PACKAGE_PIN T2   IOSTANDARD LVCMOS33 } [get_ports {sw[10]}]
set_property -dict { PACKAGE_PIN R3   IOSTANDARD LVCMOS33 } [get_ports {sw[11]}]
set_property -dict { PACKAGE_PIN W2   IOSTANDARD LVCMOS33 } [get_ports {sw[12]}]
set_property -dict { PACKAGE_PIN U1   IOSTANDARD LVCMOS33 } [get_ports {sw[13]}]
set_property -dict { PACKAGE_PIN T1   IOSTANDARD LVCMOS33 } [get_ports {sw[14]}]
set_property -dict { PACKAGE_PIN R2   IOSTANDARD LVCMOS33 } [get_ports {sw[15]}]

## ---------------- Buttons: btn[4:0] = {D, R, L, U, C} ----------------
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports {btn[0]}]
set_property -dict { PACKAGE_PIN T18  IOSTANDARD LVCMOS33 } [get_ports {btn[1]}]
set_property -dict { PACKAGE_PIN W19  IOSTANDARD LVCMOS33 } [get_ports {btn[2]}]
set_property -dict { PACKAGE_PIN T17  IOSTANDARD LVCMOS33 } [get_ports {btn[3]}]
set_property -dict { PACKAGE_PIN U17  IOSTANDARD LVCMOS33 } [get_ports {btn[4]}]

## ---------------- Timing exceptions ----------------
## All of these are asynchronous to sys_clk: inputs go through 2-FF
## synchronizers, outputs are sampled by an external device with its
## own timing (SPI: budget handled in RTL + ESP input_delay_ns).
set_false_path -from [get_ports {spi_cs_n spi_sclk spi_mosi ext_rst_n sw[*] btn[*] gpio[*]}]
set_false_path -to   [get_ports {spi_miso irq led[*] gpio[*]}]

## ---------------- Configuration ----------------
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]