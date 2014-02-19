#!/bin/sh


rm -f *.tmp tmp.*

echo $1
if [ ! -n "$1" ]
then
	echo error:no parameter
	exit
fi

fileLength=`ls -l $1 | awk '{print $5}'`
echo "fileLength = $fileLength"

#alignment
alignment=`echo $fileLength | awk '{print 4-$1%4}'`
echo "old alignment is $alignment"
if [ $alignment -eq "4" ]
then
	alignment=0
fi


#fl_alignment
fl_alignment=`echo $fileLength $alignment | awk '{print $1+$2}'`
echo "fl_alignment is $fl_alignment"

#multipleBB.bin map.bin
cd BB
./multipleBB.sh $fl_alignment
cd ../

#padding.tmp
dd if=/dev/zero of=padding.tmp bs=1 count=$alignment

#flag.tmp
echo 0x00000000 | xxd -r > flag.tmp
echo 0xaaaaaaaa | xxd -r >> flag.tmp

#new-classes.dex
cat $1 padding.tmp BB/multipleBB.bin flag.tmp BB/map.bin flag.tmp >> new-classes.dex.tmp

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

rm -f tmp.* *.tmp

