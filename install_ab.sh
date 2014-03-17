#!/bin/bash
./multiple_exe_ab.sh
adb uninstall uk.ac.ic.doc.gea05.benchmark
adb install ab/dist/dest.apk
