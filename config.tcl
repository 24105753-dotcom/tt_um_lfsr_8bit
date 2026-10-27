set ::env(DESIGN_NAME) "tt_um_lfsr_8bit"
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/project.v]
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "10.0"

# Cấu hình diện tích nhỏ cho Tiny Tapeout Tile 1x1
set ::env(FP_CORE_UTIL) 35
set ::env(SYNTH_MAX_FANOUT) 5

