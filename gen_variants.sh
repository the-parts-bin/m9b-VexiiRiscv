#!/usr/bin/env bash
# 2026-11-20: relaxed-path CPU variants for the 60 MHz margin hunt
cd "$(dirname "$0")"
F="--with-rvf --fma-reduced-accuracy"
./gen.sh rb $F --relaxed-btb --relaxed-btb-hit > gen/rb.log 2>&1
./gen.sh rx $F --relaxed-mul-inputs --fpu-relaxed-int --relaxed-div > gen/rx.log 2>&1
./gen.sh ra $F --relaxed-btb --relaxed-btb-hit --relaxed-mul-inputs --fpu-relaxed-int --relaxed-div > gen/ra.log 2>&1
echo gen-done
