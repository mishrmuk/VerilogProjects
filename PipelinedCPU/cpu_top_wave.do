onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {CLOCK / RESET}
add wave -noupdate /cpu_top_tb/clk
add wave -noupdate /cpu_top_tb/reset
add wave -noupdate -divider {IF STAGE}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_next
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_plus4
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_branch
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_branch_or_plus4
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/instr
add wave -noupdate -divider {IF/ID PIPELINE REG}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/if_id_pc
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/if_id_pc_plus4
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/if_id_instr
add wave -noupdate /cpu_top_tb/dut/dut/if_id/flush
add wave -noupdate -divider {ID STAGE CONTROL}
add wave -noupdate /cpu_top_tb/dut/dut/RegWrite
add wave -noupdate /cpu_top_tb/dut/dut/Reg2Loc
add wave -noupdate /cpu_top_tb/dut/dut/ALUSrc
add wave -noupdate /cpu_top_tb/dut/dut/MemToReg
add wave -noupdate /cpu_top_tb/dut/dut/ctrl_memwrite
add wave -noupdate /cpu_top_tb/dut/dut/ctrl_memread
add wave -noupdate /cpu_top_tb/dut/dut/ALUCtrl
add wave -noupdate /cpu_top_tb/dut/dut/ImmSel
add wave -noupdate /cpu_top_tb/dut/dut/SetFlags
add wave -noupdate /cpu_top_tb/dut/dut/UncondBranch
add wave -noupdate /cpu_top_tb/dut/dut/BranchLT
add wave -noupdate /cpu_top_tb/dut/dut/CBZBranch
add wave -noupdate /cpu_top_tb/dut/dut/BR
add wave -noupdate /cpu_top_tb/dut/dut/BL
add wave -noupdate -divider {ID STAGE REGFILE / WB->ID BYPASS}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/Rn
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/Rm
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/Rd
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/ReadReg2
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/WriteReg
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ReadData1
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ReadData2
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ID_ReadData1
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ID_ReadData2
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ImmExt
add wave -noupdate -divider {ALL REGISTERS}
add wave -noupdate -label X0 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[0]}
add wave -noupdate -label X1 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[1]}
add wave -noupdate -label X2 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[2]}
add wave -noupdate -label X3 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[3]}
add wave -noupdate -label X4 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[4]}
add wave -noupdate -label X5 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[5]}
add wave -noupdate -label X6 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[6]}
add wave -noupdate -label X7 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[7]}
add wave -noupdate -label X8 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[8]}
add wave -noupdate -label X9 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[9]}
add wave -noupdate -label X10 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[10]}
add wave -noupdate -label X11 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[11]}
add wave -noupdate -label X12 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[12]}
add wave -noupdate -label X13 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[13]}
add wave -noupdate -label X14 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[14]}
add wave -noupdate -label X15 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[15]}
add wave -noupdate -label X16 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[16]}
add wave -noupdate -label X17 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[17]}
add wave -noupdate -label X18 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[18]}
add wave -noupdate -label X19 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[19]}
add wave -noupdate -label X20 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[20]}
add wave -noupdate -label X21 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[21]}
add wave -noupdate -label X22 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[22]}
add wave -noupdate -label X23 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[23]}
add wave -noupdate -label X24 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[24]}
add wave -noupdate -label X25 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[25]}
add wave -noupdate -label X26 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[26]}
add wave -noupdate -label X27 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[27]}
add wave -noupdate -label X28 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[28]}
add wave -noupdate -label X29 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[29]}
add wave -noupdate -label X30 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[30]}
add wave -noupdate -label X31 -radix decimal {/cpu_top_tb/dut/dut/RF/regs[31]}
add wave -noupdate -divider {ID/EX PIPELINE REG}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_pc
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_pc_plus4
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/id_ex_read_data1
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/id_ex_read_data2
add wave -noupdate -radix decimal /cpu_top_tb/dut/dut/id_ex_imm
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_rn
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_rm
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_rd
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_ALUSrc
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_ALUCtrl
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_MemRead
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_MemWrite
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_Branch
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_UncondBranch
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_CBZBranch
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_BR
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_RegWrite
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_MemToReg
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_BL
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_SetFlags
add wave -noupdate -divider {EX STAGE / FORWARDING}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_rn
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_rm
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/ex_mem_rd
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/mem_wb_rd
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_RegWrite
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_RegWrite
add wave -noupdate -radix binary /cpu_top_tb/dut/dut/ForwardA
add wave -noupdate -radix binary /cpu_top_tb/dut/dut/ForwardB
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/id_ex_read_data1
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/id_ex_read_data2
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/WriteData
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ex_mem_alu_result
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ALUInputA
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ForwardedB
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ALUInputB
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ALUResult
add wave -noupdate /cpu_top_tb/dut/dut/zero
add wave -noupdate /cpu_top_tb/dut/dut/negative
add wave -noupdate /cpu_top_tb/dut/dut/overflow
add wave -noupdate /cpu_top_tb/dut/dut/carry_out
add wave -noupdate -divider {FLAGS / B.LT DEBUG}
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/flags_in
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/flags_out
add wave -noupdate /cpu_top_tb/dut/dut/flag_negative
add wave -noupdate /cpu_top_tb/dut/dut/flag_zero
add wave -noupdate /cpu_top_tb/dut/dut/flag_overflow
add wave -noupdate /cpu_top_tb/dut/dut/flag_carry_out
add wave -noupdate /cpu_top_tb/dut/dut/lt_condition
add wave -noupdate /cpu_top_tb/dut/dut/take_lt
add wave -noupdate -divider {BRANCH DEBUG}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/id_ex_pc
add wave -noupdate -radix decimal /cpu_top_tb/dut/dut/id_ex_imm
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_branch
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_branch_or_plus4
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/pc_next
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_UncondBranch
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_CBZBranch
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_Branch
add wave -noupdate /cpu_top_tb/dut/dut/id_ex_BR
add wave -noupdate /cpu_top_tb/dut/dut/take_cbz
add wave -noupdate /cpu_top_tb/dut/dut/take_lt
add wave -noupdate /cpu_top_tb/dut/dut/BranchTaken
add wave -noupdate /cpu_top_tb/dut/dut/if_id/flush
add wave -noupdate -divider {EX/MEM PIPELINE REG}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/ex_mem_branch_target
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ex_mem_alu_result
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/ex_mem_write_data
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/ex_mem_pc_plus4
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_zero
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_branch_taken
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/ex_mem_rd
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_MemRead
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_MemWrite
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_RegWrite
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_MemToReg
add wave -noupdate /cpu_top_tb/dut/dut/ex_mem_BL
add wave -noupdate -divider {MEM STAGE / DATA MEMORY}
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/dataadr
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/writedata
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/read_data
add wave -noupdate /cpu_top_tb/dut/dut/memwrite
add wave -noupdate /cpu_top_tb/dut/dut/memread
add wave -noupdate /cpu_top_tb/dut/dut/xfer_size
add wave -noupdate -divider {MEM/WB PIPELINE REG}
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/mem_wb_read_data
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/mem_wb_alu_result
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/mem_wb_pc_plus4
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/mem_wb_rd
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_RegWrite
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_MemToReg
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_BL
add wave -noupdate -divider {WRITEBACK DEBUG}
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/mem_wb_rd
add wave -noupdate -radix unsigned /cpu_top_tb/dut/dut/WriteReg
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_RegWrite
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_MemToReg
add wave -noupdate /cpu_top_tb/dut/dut/mem_wb_BL
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/mem_wb_alu_result
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/mem_wb_read_data
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/mem_wb_pc_plus4
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/WBData
add wave -noupdate -radix hexadecimal /cpu_top_tb/dut/dut/WriteData
add wave -noupdate /cpu_top_tb/dut/dmem/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 160
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {106260 ns}
