#!/bin/bash
set -x

unicore32-linux-as test.S
unicore32-linux-objcopy -O binary a.out test.bin
rm ../BB-24fe.bin
cp test.bin ../BB-24fe.bin
