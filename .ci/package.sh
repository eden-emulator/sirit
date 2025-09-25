#!/bin/sh -ex

cmake --install build --prefix install

[ "$ARCH" != "amd64" ] && [ "$PLATFORM" != "android" ] && PLATFORM=$PLATFORM-$ARCH

ROOTDIR=$PWD
mkdir -p artifacts

cd install

TARBALL=sirit-$PLATFORM-$VERSION.tar.zst

tar --zstd -cf $ROOTDIR/artifacts/$TARBALL *

cd $ROOTDIR/artifacts

../.ci/sums.sh $TARBALL