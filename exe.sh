#!/bin/bash
cd test
./test.sh
cd ..
#./compose.sh classes.dex BB-24fe.bin
#./debug_compose.sh classes.dex BB-24fe.bin
./map_compose.sh classes.dex BB-24fe.bin
./makeDex.sh new-classes.dex 
./apk.sh
