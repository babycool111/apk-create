#!/bin/bash

#apktool d -s com.android.cm3_1.apk cm3/
#mv cm3/classes.dex cm3/classes.dex.bak
rm -r ab/dist/ ab/build/
cp new-classes.dex ab/classes.dex
apktool b -f ab/
cd ab/dist/
cp ../../cmd.keystore ./
jarsigner -verbose -keystore cmd.keystore -signedjar dest.apk Android-Benchmark.apk cmd.keystore << EOF
124578
124578120
EOF

