#!/bin/sh

# Generates a "changelog"/download utility table
# Requires: echo

# Change to the current repo
BASE_DOWNLOAD_URL="https://github.com/eden-emulator/sirit/releases/download"
TAG=$VERSION
VERSION=$(echo $TAG | tr -d "v")

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

echo "This is version $VERSION of Eden's fork of sirit."
echo
echo "Compared to ReinUsesLisp's original project, this fork of sirit contains all of the changes made by RaphaelTheGreat (as seen in ShadPS4),"
echo "alongside build system improvements and CI made by crueter and others. For use within projects, this should be identical to Raphael's fork,"
echo "however UNIX-like operating systems can now install this as a system package and integrate it via CMake."
echo
echo "| Build | sha1sum | sha256sum | sha512sum |"
echo "| ----- | ------- | --------- | --------- |"

artifact Android android
artifact "Windows (amd64)" windows-amd64
artifact "Windows (arm64)" windows-arm64
artifact "Linux (amd64)" linux-amd64
artifact "Linux (aarch64)" linux-aarch64
artifact "Solaris (amd64)" solaris-amd64
artifact "FreeBSD (amd64)" freebsd-amd64
artifact "OpenBSD (amd64)" openbsd-amd64
artifact macOS macos-universal
artifact Source source