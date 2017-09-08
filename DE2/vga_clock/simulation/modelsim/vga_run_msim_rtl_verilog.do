transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/rgb.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/top.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/pll.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/vga_data8.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/rom256_digits.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/ram256_data.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/clock_controller.v}
vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/b2bcd_99.v}

vlog -vlog01compat -work work +incdir+D:/ZXOPEN2017/DE2/class/vga_clock {D:/ZXOPEN2017/DE2/class/vga_clock/top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc" top_tb

add wave *
view structure
view signals
run -all
