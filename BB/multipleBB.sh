#!/bin/sh

echo "'$1' is $1 "
if [ ! -n "$1" ]
then
	echo error:no  parameter
	exit
fi

#0x0073,in final file 
op=0x7300

rm -f  multipleBB.bin map.bin
rm -f tmp.* *.tmp

touch multipleBB.bin
touch map.bin

for file in `ls BB-*.bin`
do
	echo "file is $file"

	MBLength=`ls -l multipleBB.bin | awk '{print $5}'`
	echo "MBLength = $MBLength"
	
	cat $file >> multipleBB.bin

	offsetOfDex_hex=`echo $file | awk -F "-" '{print "0x"$2}' | awk -F "." '{print $1}'`
	offsetOfDex=`printf "%d" $offsetOfDex_hex`
	echo "offsetOfDex_hex = $offsetOfDex_hex,offsetOfDex = $offsetOfDex"

	#offset for rewrite
	printf "0x%04x" $offsetOfDex | xxd -r > offsetOfDex.tmp
	rm -f tmp.offsetOfDex_*
	split -b 1 offsetOfDex.tmp tmp.offsetOfDex_
	for off in `ls -r tmp.offsetOfDex_*`
	do 
		echo "tmp.offsetOfDex_ is $off"
		cat $off >> map.bin
	done	
	
	#opcode
	echo $op | xxd -r >> map.bin
	
	#offset for searching BB
	offset4SBB=`echo "$1 $MBLength $offsetOfDex_hex" | awk '{print $1+$2-$3}'`
	echo "offset4SBB is $offset4SBB"
	printf "0x%08x" $offset4SBB | xxd -r > offset4SBB.tmp
	rm -f tmp.offset4SBB_*
	split -b 1 offset4SBB.tmp tmp.offset4SBB_
	for off in `ls -r tmp.offset4SBB_*`
	do 
		echo "tmp.offsetOfDex_ is $off"
		cat $off >> map.bin
	done
		
done


rm -f tmp.* *.tmp
