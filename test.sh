#!/usr/bin/env bash
# this_file: test.sh

set -e

dir=${0%/*}
if [ "$dir" = "$0" ]; then dir="."; fi
cd "$dir"

echo "Running tests for SVG2Keynote-lib..."

# Clean previous build
rm -rf build/test
mkdir -p build/test
cd build/test

# Configure with testing enabled
echo "Configuring build with testing..."
cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON ../..

# Build
echo "Building tests..."
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)

# Run tests
echo "Running tests..."
ctest --output-on-failure --verbose

echo "Tests completed successfully!"