#!/usr/bin/env bash
# this_file: release.sh
# Release script for creating distribution packages

set -e

dir=${0%/*}
if [ "$dir" = "$0" ]; then dir="."; fi
cd "$dir"

# Parse arguments
VERSION="${1:-$(git describe --tags --abbrev=0 2>/dev/null || echo 'v0.0.0-dev')}"
PLATFORMS="${2:-linux darwin}"
ARCHES="${3:-x86_64 arm64}"

echo "Creating release packages for SVG2Keynote-lib version $VERSION"

# Create release directory
RELEASE_DIR="release/$VERSION"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Build for each platform and architecture
for platform in $PLATFORMS; do
    for arch in $ARCHES; do
        echo "Building for $platform-$arch..."
        
        # Skip unsupported combinations
        if [ "$platform" = "linux" ] && [ "$arch" = "arm64" ]; then
            echo "Skipping linux-arm64 (not supported yet)"
            continue
        fi
        
        # Build
        ./build.sh Release "$platform" "$arch" false
        
        # Package
        PACKAGE_NAME="svg2keynote-${VERSION}-${platform}-${arch}"
        PACKAGE_DIR="$RELEASE_DIR/$PACKAGE_NAME"
        
        mkdir -p "$PACKAGE_DIR"
        
        # Copy distribution files
        cp -r "dist/${platform,,}-${arch}/"* "$PACKAGE_DIR/"
        
        # Copy documentation
        cp README.md "$PACKAGE_DIR/"
        cp LICENSE "$PACKAGE_DIR/"
        cp CHANGELOG.md "$PACKAGE_DIR/" 2>/dev/null || echo "# Changelog\n\nSee GitHub releases." > "$PACKAGE_DIR/CHANGELOG.md"
        
        # Create installation script
        cat > "$PACKAGE_DIR/install.sh" << 'EOF'
#!/usr/bin/env bash
# Installation script for SVG2Keynote-lib

set -e

INSTALL_PREFIX="${1:-/usr/local}"

echo "Installing SVG2Keynote-lib to $INSTALL_PREFIX..."

# Install library
mkdir -p "$INSTALL_PREFIX/lib"
cp libkeynote_lib.a "$INSTALL_PREFIX/lib/"

# Install headers
mkdir -p "$INSTALL_PREFIX/include/svg2keynote"
cp include/*.h "$INSTALL_PREFIX/include/svg2keynote/"

# Install binary (if available)
if [ -f svg2key ]; then
    mkdir -p "$INSTALL_PREFIX/bin"
    cp svg2key "$INSTALL_PREFIX/bin/"
fi

echo "Installation completed!"
echo "Library: $INSTALL_PREFIX/lib/libkeynote_lib.a"
echo "Headers: $INSTALL_PREFIX/include/svg2keynote/"
if [ -f svg2key ]; then
    echo "Binary: $INSTALL_PREFIX/bin/svg2key"
fi
EOF
        
        chmod +x "$PACKAGE_DIR/install.sh"
        
        # Create archive
        cd "$RELEASE_DIR"
        tar -czf "$PACKAGE_NAME.tar.gz" "$PACKAGE_NAME"
        rm -rf "$PACKAGE_NAME"
        cd ..
    done
done

# Create checksums
cd "$RELEASE_DIR"
sha256sum *.tar.gz > checksums.sha256
cd ..

echo "Release packages created in: $RELEASE_DIR"
echo "Available packages:"
ls -la "$RELEASE_DIR"

echo ""
echo "Release ready! Upload these files to GitHub Releases:"
echo "- All .tar.gz files"
echo "- checksums.sha256"