#!/bin/sh

#opCode
op=0x73;
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
echo "fileLength = $fileLength"

bbEntryPosHex=`echo $2 | awk -F "-" '{print "0x"$2}' | awk -F "." '{print $1}'`
echo "bbEntryPosHex = $bbEntryPosHex"

bbEntryPos=`printf "%d" $bbEntryPosHex`
echo "bbEntryPos = $bbEntryPos"

bbEntryPosAfter=`echo $bbEntryPos | awk '{print $1+2}'`
echo "bbEntryPosAfter = $bbEntryPosAfter"

alignment=`echo $fileLength $bbEntryPos | awk '{print 4-($1+$2)%4}'`
echo "alignmentHex = $alignment"
if [ $alignment -eq "4" ]
then
	alignment=0
fi

alignmentHex=`printf "0x%02x" $alignment`
echo "alignmentHex = $alignmentHex"

left=`echo $bbEntryPos $alignment | awk '{print $1+$2}'`
echo "left = $left"


dd if=/dev/zero of=padding.tmp bs=1 count=$left
echo $op | xxd -r > tail.tmp 
#opcode-op
echo $alignmentHex | xxd -r >> tail.tmp 
#opcode-offset
echo 0x0000 | xxd -r >> tail.tmp
#reserve

#offset
printf "0x%08x" $bbEntryPos | xxd -r >> bbEntryPos.tmp
split -b 1 bbEntryPos.tmp tmp.bbEP_
cat tmp.bbEP_ad tmp.bbEP_ac tmp.bbEP_ab tmp.bbEP_aa >> tail.tmp

#flag
echo 0x00000000 | xxd -r > flag.tmp
echo 0xaaaaaaaa | xxd -r >>flag.tmp


cat $1 padding.tmp $2 flag.tmp tail.tmp flag.tmp > new-classes.dex.tmp

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

#rm -f *.tmp tmp.*




