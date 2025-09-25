#!/bin/sh -ex

cmake --install build --prefix install

[ "$ARCH" != "amd64" ] && [ "$PLATFORM" != "android" ] && PLATFORM=$PLATFORM-$ARCH

ROOTDIR=$PWD
mkdir -p artifacts

cd install
cp $ROOTDIR/dist/CMakeLists.txt .

TARBALL=sirit-$PLATFORM-$VERSION.tar

# annoying
if [ "$PLATFORM" = "windows-arm64" ]; then
    tar cf $ROOTDIR/artifacts/$TARBALL *
else
    TARBALL=$TARBALL.zst
    tar --zstd -cf $ROOTDIR/artifacts/$TARBALL *
    cd $ROOTDIR/artifacts
    ../.ci/sums.sh $TARBALL
fi