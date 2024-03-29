transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {andgate.vo}

vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/andgate {D:/ZXOPEN2017/DE2/class/andgate/andgate_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc" andgate_tb

add wave *
view structure
view signals
run -all
