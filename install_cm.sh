#!/bin/bash
./multiple_exe_cm.sh
adb uninstall com.android.cm3
adb install cm3/dist/dest.apk
