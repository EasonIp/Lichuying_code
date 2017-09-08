transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/class/adc {D:/ZXOPEN2017/class/adc/adc.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/class/adc {D:/ZXOPEN2017/class/adc/seg7.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/class/adc {D:/ZXOPEN2017/class/adc/top.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/class/adc {D:/ZXOPEN2017/class/adc/pre_seg7.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/class/adc {D:/ZXOPEN2017/class/adc/post_seg7.v}

vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/class/adc {D:/ZXOPEN2017/class/adc/adc_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  adc_tb

add wave *
view structure
view signals
run -all