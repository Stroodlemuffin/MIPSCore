onerror {resume}
quietly set dataset_list [list sim vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048536]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048537]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048538]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048539]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048540]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048541]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048542]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048543]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048544]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048545]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048546]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048547]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048548]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048549]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048550]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048551]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048552]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048553]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048554]}
add wave -noupdate {sim:/pd3_tb/loadstore_mod/data_mem_module/memory[1048555]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {188 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 260
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {744 ns}
