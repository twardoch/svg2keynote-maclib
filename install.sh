#!/usr/bin/env bash
# this_file: install.sh
# Installation script for SVG2Keynote-lib

set -e

# Configuration
DEFAULT_PREFIX="/usr/local"
GITHUB_REPO="eth-siplab/SVG2Keynote-lib"
LATEST_RELEASE_URL="https://api.github.com/repos/$GITHUB_REPO/releases/latest"

# Parse arguments
PREFIX="${1:-$DEFAULT_PREFIX}"
VERSION="${2:-latest}"
PLATFORM="${3:-auto}"
ARCH="${4:-auto}"

# Detect platform and architecture
if [ "$PLATFORM" = "auto" ]; then
    case "$(uname -s)" in
        Darwin) PLATFORM="darwin" ;;
        Linux) PLATFORM="linux" ;;
        *) echo "Unsupported platform: $(uname -s)"; exit 1 ;;
    esac
fi

if [ "$ARCH" = "auto" ]; then
    case "$(uname -m)" in
        x86_64) ARCH="x86_64" ;;
        arm64|aarch64) ARCH="arm64" ;;
        *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
    esac
fi

echo "Installing SVG2Keynote-lib..."
echo "Platform: $PLATFORM, Architecture: $ARCH"
echo "Install prefix: $PREFIX"

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download and extract
if [ "$VERSION" = "latest" ]; then
    echo "Fetching latest release information..."
    DOWNLOAD_URL=$(curl -s "$LATEST_RELEASE_URL" | grep -o "https://github.com/$GITHUB_REPO/releases/download/[^\"]*$PLATFORM-$ARCH.tar.gz" | head -1)
    if [ -z "$DOWNLOAD_URL" ]; then
        echo "Error: Could not find download URL for $PLATFORM-$ARCH"
        echo "Available releases:"
        curl -s "$LATEST_RELEASE_URL" | grep -o "https://github.com/$GITHUB_REPO/releases/download/[^\"]*\.tar\.gz"
        exit 1
    fi
else
    DOWNLOAD_URL="https://github.com/$GITHUB_REPO/releases/download/v$VERSION/svg2keynote-v$VERSION-$PLATFORM-$ARCH.tar.gz"
fi

echo "Downloading from: $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o package.tar.gz

echo "Extracting package..."
tar -xzf package.tar.gz

# Find the extracted directory
EXTRACT_DIR=$(find . -name "svg2keynote-*" -type d | head -1)
if [ -z "$EXTRACT_DIR" ]; then
    echo "Error: Could not find extracted directory"
    exit 1
fi

cd "$EXTRACT_DIR"

# Install
echo "Installing to $PREFIX..."

# Install library
mkdir -p "$PREFIX/lib"
cp libkeynote_lib.a "$PREFIX/lib/"

# Install headers
mkdir -p "$PREFIX/include/svg2keynote"
cp include/*.h "$PREFIX/include/svg2keynote/"

# Install binary (if available)
if [ -f svg2key ]; then
    mkdir -p "$PREFIX/bin"
    cp svg2key "$PREFIX/bin/"
fi

# Install documentation
mkdir -p "$PREFIX/share/doc/svg2keynote"
cp README.md "$PREFIX/share/doc/svg2keynote/"
cp LICENSE "$PREFIX/share/doc/svg2keynote/"
[ -f CHANGELOG.md ] && cp CHANGELOG.md "$PREFIX/share/doc/svg2keynote/"

# Cleanup
cd /
rm -rf "$TMP_DIR"

echo "Installation completed successfully!"
echo ""
echo "Installed files:"
echo "  Library: $PREFIX/lib/libkeynote_lib.a"
echo "  Headers: $PREFIX/include/svg2keynote/"
if [ -f "$PREFIX/bin/svg2key" ]; then
    echo "  Binary: $PREFIX/bin/svg2key"
fi
echo "  Documentation: $PREFIX/share/doc/svg2keynote/"
echo ""
echo "To use the library in your CMake project:"
echo "  find_library(SVG2KEYNOTE_LIB keynote_lib PATHS $PREFIX/lib)"
echo "  target_include_directories(your_target PRIVATE $PREFIX/include/svg2keynote)"
echo "  target_link_libraries(your_target \${SVG2KEYNOTE_LIB})"
echo ""
if [ -f "$PREFIX/bin/svg2key" ]; then
    echo "To use the CLI tool:"
    echo "  $PREFIX/bin/svg2key < input.svg"
    echo "  # Then paste in Keynote with Cmd+V"
fi