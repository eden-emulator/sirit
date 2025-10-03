#!/bin/sh -ex

cmake --install build --prefix install

[ "$PLATFORM" != "android" ] && PLATFORM=$PLATFORM-$ARCH

ROOTDIR=$PWD
mkdir -p artifacts

cd install
cp -r $ROOTDIR/externals/SPIRV-Headers/include/spirv include
cp $ROOTDIR/dist/CMakeLists.txt .

VERSION=$(echo $VERSION | tr -d "v")
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