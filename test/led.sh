#!/bin/bash
set -x

unicore32-linux-as led.S -o led.out
unicore32-linux-objcopy -O binary led.out led.bin
