#!/usr/bin/env bash
# this_file: build.sh
# Enhanced build script with multiplatform support

set -e

dir=${0%/*}
if [ "$dir" = "$0" ]; then dir="."; fi
cd "$dir"

# Parse arguments
BUILD_TYPE="${1:-Release}"
PLATFORM="${2:-$(uname -s)}"
ARCH="${3:-$(uname -m)}"
SKIP_TESTS="${4:-false}"

echo "Building SVG2Keynote-lib..."
echo "Platform: $PLATFORM, Architecture: $ARCH, Build Type: $BUILD_TYPE"

BUILD_DIR="build/${PLATFORM,,}-${ARCH}"
DIST_DIR="dist/${PLATFORM,,}-${ARCH}"

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure build
CMAKE_ARGS="-DCMAKE_BUILD_TYPE=$BUILD_TYPE"

if [ "$PLATFORM" = "Darwin" ]; then
    CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_OSX_ARCHITECTURES=$ARCH"
fi

if [ "$SKIP_TESTS" = "false" ]; then
    CMAKE_ARGS="$CMAKE_ARGS -DBUILD_TESTING=ON"
fi

echo "Configuring build..."
cmake $CMAKE_ARGS ../..

# Build
echo "Building..."
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)

# Run tests if enabled
if [ "$SKIP_TESTS" = "false" ]; then
    echo "Running tests..."
    if ! ctest --output-on-failure; then
        echo "Tests failed!"
        exit 1
    fi
fi

# Create distribution
cd ../..
mkdir -p "$DIST_DIR"

# Copy binaries
if [ "$PLATFORM" = "Darwin" ]; then
    if [ -f "$BUILD_DIR/svg2key" ]; then
        cp "$BUILD_DIR/svg2key" "$DIST_DIR/"
    fi
fi

# Copy library
if [ -f "$BUILD_DIR/keynote_lib/libkeynote_lib.a" ]; then
    cp "$BUILD_DIR/keynote_lib/libkeynote_lib.a" "$DIST_DIR/"
fi

# Copy headers
mkdir -p "$DIST_DIR/include"
cp keynote_lib/headers/*.h "$DIST_DIR/include/"

if [ -f "$BUILD_DIR/version.hpp" ]; then
    cp "$BUILD_DIR/version.hpp" "$DIST_DIR/include/"
fi

echo "Build completed successfully!"
echo "Distribution files available in: $DIST_DIR"

