#restart simulation
restart

#remove all current waves
remove_wave [get_waves *]

#add desired waves
add_wave /

#execute simulation
run 50 ns