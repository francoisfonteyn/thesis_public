#!/bin/bash

dir=$(echo "$0"|awk -F "/" '{F=""; for(A=1; A<NF; ++A) {F=F$A"/";} print(F);}')
cd "$dir"
cd mozart2-build
rm -r *
cmake  -DGTEST_SRC_DIR=../gtest -DGTEST_BUILD_DIR=../gtest-debug \
 -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
 -DLLVM_SRC_DIR=../llvm -DLLVM_BUILD_DIR=../llvm-build \
 -DCMAKE_BUILD_TYPE=Release ../mozart2
make -j `sysctl -n hw.ncpu`
cpack -G Bundle
open mozart2-unknown-x86_64-darwin.dmg
