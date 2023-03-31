#!/usr/bin/env bash
dir=${0%/*}
if [ "$dir" = "$0" ]; then dir="."; fi
cd "$dir"
echo "Running: brew install snappy protobuf boost"
#brew uninstall --ignore-dependencies snappy protobuf boost && brew install snappy protobuf boost 
# echo "Extracting protos from /Applications/Keynote.app..."
# cd keynote-protos
# ./get-protos.sh
## THIS FAILS ## ./dump-mappings.sh
# cd ..

arch=$(uname -m)

echo "Generating Makefile for '$arch'..."
mkdir -p build/$arch
cd build/$arch
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=$arch ../..
echo "Building for '$arch'..."
make
cd ../..
mkdir -p dist/$arch
cp "build/$arch/svg2key" "dist/$arch/"
