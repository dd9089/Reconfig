onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib axis_data_fifo_recieve_opt

do {wave.do}

view wave
view structure
view signals

do {axis_data_fifo_recieve.udo}

run -all

quit -force
