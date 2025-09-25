#!/bin/sh -ex

cmake --install build --prefix install

if [ "$ARCH" != "amd64" ] || [ "$PLATFORM" == "windows" ]; then
    [ "$PLATFORM" != "android" ] && PLATFORM=$PLATFORM-$ARCH
fi

ROOTDIR=$PWD
mkdir -p artifacts

cd install
cp $ROOTDIR/dist/CMakeLists.txt .

TARBALL=sirit-$PLATFORM-$VERSION.tar

# annoying
if [ "$PLATFORM" = "windows-arm64" ]; then
    tar cf $ROOTDIR/artifacts/$TARBALL *
else
    tar -cf $ROOTDIR/artifacts/$TARBALL *

    cd $ROOTDIR/artifacts
    zstd -10 $TARBALL
    rm $TARBALL

    ../.ci/sums.sh $TARBALL.zst
fi