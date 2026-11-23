#!/usr/bin/env bash
# Generates VexiiRiscv.v with the m20's options (plus any given) into
# gen/$1/, in the fork's Docker image. Usage: gen.sh NAME [extra options]
set -euo pipefail
cd "$(dirname "$0")"
name=$1; shift
mkdir -p "gen/$name" .dockerhome
OPTS="--xlen 32 --physical-width 24 --with-rvm --with-rvZcbm --with-rvZba --lsu-software-prefetch \
--reset-vector 0 --allow-bypass-from 0 --with-btb --with-ras \
--relaxed-branch --relaxed-shift --regfile-async --fetch-l1 --fetch-wishbone \
--fetch-l1-sets 128 --fetch-l1-ways 1 --fetch-l1-mem-data-width-min 64 \
--lsu-l1 --lsu-l1-wishbone --lsu-wishbone --lsu-l1-sets 128 \
--lsu-l1-ways 2 --lsu-l1-mem-data-width-min 64 \
--with-rvZicboz --lsu-l1-word-writes --lsu-l1-wishbone-unbuffered \
--div-radix 4 \
--btb-hash-width 11 --btb-target-width 21 \
--region base=0,size=20000,main=1,exe=1 \
--region base=800000,size=800000,main=1,exe=1 \
--region base=400000,size=400000,main=0,exe=0 $*"
docker run --rm -v "$PWD:/work" -w /work --user "$(id -u):$(id -g)" -e HOME=/work/.dockerhome \
    --entrypoint bash leviathanch/vexiiriscv -c "sbt \"runMain vexiiriscv.Generate $OPTS\"" 2>&1 | tail -40
mv VexiiRiscv.v "gen/$name/VexiiRiscv.v"
echo "options: $OPTS" > "gen/$name/options.txt"
