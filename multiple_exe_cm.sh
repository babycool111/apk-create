#!/bin/bash
#cd test
#./test.sh
#cd ..
cp cm3/classes.dex classes.dex
./multiple_compose.sh classes.dex 

#./map_compose.sh classes.dex BB-24fc.bin
./makeDex.sh new-classes.dex 
./apk_cm.sh
