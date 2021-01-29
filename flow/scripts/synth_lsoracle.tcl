# generic synthesis
synth  -top $::env(DESIGN_NAME) -flatten
stat
#lsoracle -lso_exe /OpenROAD-flow/tools/build/LSOracle/build/core/lsoracle
stat



abc -script $abc_resyn2_script
#abc -script $abc_resyn2rs_script
techmap



# Optimize the design
opt -purge
stat
# technology mapping of latches
if {[info exist ::env(LATCH_MAP_FILE)]} {
  techmap -map $::env(LATCH_MAP_FILE)
}
stat
# technology mapping of flip-flops
dfflibmap -liberty $::env(OBJECTS_DIR)/merged.lib
opt
stat
# Technology mapping for cells
abc -D [expr $::env(CLOCK_PERIOD) * 1000] \
    -constr "$::env(SDC_FILE)" \
    -liberty $::env(OBJECTS_DIR)/merged.lib \
    -script $abc_script \
    -showtmp



# technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
        -hicell {*}$::env(TIEHI_CELL_AND_PORT) \
        -locell {*}$::env(TIELO_CELL_AND_PORT)



# replace undef values with defined constants
setundef -zero



# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets



# insert buffer cells for pass through wires
insbuf -buf {*}$::env(MIN_BUF_CELL_AND_PORTS)



# remove unused cells and wires
opt_clean -purge



# reports
tee -o $::env(REPORTS_DIR)/synth_check.txt check
tee -o $::env(REPORTS_DIR)/synth_stat.txt stat -liberty $::env(OBJECTS_DIR)/merged.lib



# write synthesized design
write_verilog -noattr -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_1_yosys.v
