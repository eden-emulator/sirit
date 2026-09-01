#!/bin/sh -ex

# Generate SHA512 sums for all input files

for file in "$@"; do
	sha512sum "$file" | cut -d " " -f1 | tr -d "\n" > "$file".sha512sum
done