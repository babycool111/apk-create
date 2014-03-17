#!/bin/bash
#cd test
#./test.sh
#cd ..
cp ab/classes.dex classes.dex
./multiple_compose.sh classes.dex 

#./map_compose.sh classes.dex BB-24fc.bin
./makeDex.sh new-classes.dex 
./apk_ab.sh
