#!/bin/sh -ex

cmake --install build --prefix install

PLATFORM=$PLATFORM-$ARCH

ROOTDIR=$PWD
mkdir -p artifacts

cd install
cp -r "$ROOTDIR"/externals/SPIRV-Headers/include/spirv include
cp "$ROOTDIR"/dist/CMakeLists.txt .

TARBALL=sirit-$PLATFORM-$VERSION.tar

tar -cf "$ROOTDIR"/artifacts/"$TARBALL" ./*

cd "$ROOTDIR"/artifacts
zstd -10 "$TARBALL"
rm "$TARBALL"

../.ci/sums.sh "$TARBALL".zst
