#!/bin/sh

#opcode 
op=0x7350
echo "op=$op"

rm -f *.tmp tmp.*

echo $1
if [ ! -n "$1" ]
then
	echo error:no first parameter
	exit
fi

if [ ! -n "$2" ]
then
	echo error:no second parameter
	exit
fi

fileLength=`ls -l $1 | awk '{print $5}'`
echo $fileLength

left=`ls -l $1 | awk '{print 4-$5%4}' `
echo $left

if [ $left -eq "4"  ]
then
	left=0
fi

echo "left=$left"


cat $1 padding.tmp $2 > new-classes.dex

insnPos_hex=`echo $2 | awk -F "-" '{print "0x"$2}' | awk -F "." '{print $1}' `
echo "insnPos_hex=$insnPos_hex"
insnPos=`printf "%d" $insnPos_hex`
echo "insnPos=$insnPos"


offset=`echo $fileLength $left $insnPos | awk '{print $1+$2-$3}'`
echo "offset=$offset"

Lafter=`echo $insnPos | awk '{print $1+2}'`
echo "Lafter=$Lafter"

dd if=$1 of=before-dex.tmp bs=1 count=$insnPos
echo $op | xxd -r > opcode.tmp
#dd if=/dev/zero bs=1 count=1 >> opcode.tmp
#echo 0x0132 | xxd -r > opcode.tmp
dd if=$1 of=after-dex.tmp bs=1  skip=$Lafter  
dd if=/dev/zero of=padding.tmp bs=1 count=$left

cat before-dex.tmp opcode.tmp after-dex.tmp padding.tmp $2 > new-classes.dex.tmp

#Add length to .dex file
dd if=new-classes.dex.tmp of=new-classes.dex bs=1 count=32
file_size=`ls -l new-classes.dex.tmp | awk '{print $5}'`
echo "file_size = $file_size"
file_size_hex=`printf "0x%08X" $file_size`
echo "file_size_hex=$file_size_hex"
echo $file_size_hex | xxd -r > file_size.tmp
split -b 1 file_size.tmp tmp.fs_
cat tmp.fs_ad tmp.fs_ac tmp.fs_ab tmp.fs_aa >> new-classes.dex
dd if=new-classes.dex.tmp bs=1 skip=36 >> new-classes.dex

rm -f *.tmp tmp.*
