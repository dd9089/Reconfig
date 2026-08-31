#restart simulation
restart

#remove all current waves
remove_wave [get_waves *]

#add desired waves
add_wave /
add_wave /uut/sel

#execute simulation
run 150 ns