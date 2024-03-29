transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {and_gate_min_1200mv_0c_fast.vo}

vlog -vlog01compat -work work +incdir+D:/ZXOPEN2016/class/and_gate {D:/ZXOPEN2016/class/and_gate/and_gate_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  and_gate_tb

add wave *
view structure
view signals
run -all
