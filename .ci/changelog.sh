#!/bin/sh

# Generates a "changelog"/download utility table
# Requires: echo

# Change to the current repo
BASE_DOWNLOAD_URL="https://github.com/eden-emulator/sirit/releases/download"
TAG=v$VERSION

artifact() {
  NAME="$1"
  PLATFORM="$2"

  BASE_URL="${BASE_DOWNLOAD_URL}/${TAG}/sirit-${PLATFORM}-${VERSION}.tar.zst"

  echo -n "| "
  echo -n "[$NAME]($BASE_URL) | "
  for sum in 1 256 512; do
    echo -n "[Download]($BASE_URL.sha${sum}sum) |"
  done
  echo
}

echo "Builds for $PRETTY_NAME $VERSION"
echo
echo "| Build | sha1sum | sha256sum | sha512sum |"
echo "| ----- | ------- | --------- | --------- |"

artifact Android android
artifact "Windows (amd64)" windows-amd64
artifact "Windows (arm64)" windows-arm64
artifact Linux linux
artifact "Linux (aarch64)" linux-aarch64
artifact Solaris solaris
artifact FreeBSD freebsd
artifact OpenBSD openbsd
artifact macOS macos-universal
artifact Source source