#!/bin/bash

#apktool d -s com.android.cm3_1.apk cm3/
#mv cm3/classes.dex cm3/classes.dex.bak
rm -r cm3/dist/ cm3/build/
cp new-classes.dex cm3/classes.dex
apktool b -f cm3/
cd cm3/dist/
cp ../../cmd.keystore ./
jarsigner -verbose -keystore cmd.keystore -signedjar dest.apk com.android.cm3_1.apk cmd.keystore << EOF
124578
124578120
EOF

