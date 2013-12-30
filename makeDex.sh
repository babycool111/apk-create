#!/bin/sh
rm -f *.tmp *.tmp0*
dd if=$1 of=magic.tmp bs=1 count=8
dd if=$1 of=basicData.tmp bs=1 skip=32

sha1sum basicData.tmp | awk '{print $1}' > sha1sumValue.tmp
split -b 20 -d sha1sumValue.tmp sha1sum.tmp
cat sha1sum.tmp00 | awk '{print "0x"$0}' | xxd -r  > sha1sum00.tmp
cat sha1sum.tmp01 | awk '{print "0x"$0}' | xxd -r  > sha1sum01.tmp

cat sha1sum00.tmp sha1sum01.tmp basicData.tmp > sha1sum-classes.tmp

jacksum -a adler-32 -x sha1sum-classes.tmp | awk '{print $1}'  >adler32-origin.tmp
split -b 2 -d adler32-origin.tmp adler32.tmp
cat adler32.tmp03 adler32.tmp02 adler32.tmp01 adler32.tmp00 | awk '{print "0x"$0}' | xxd -r > adler32.tmp

cat magic.tmp adler32.tmp sha1sum-classes.tmp > new-classes.dex

rm -f *.tmp  *.tmp0*

