# Git Tag-based Semver CI/CD Implementation Plan

## Project Overview
Implement git-tag-based semantic versioning for SVG2Keynote-lib with comprehensive testing, build automation, and GitHub Actions CI/CD pipeline supporting multiplatform releases.

## Current State Analysis
- **Language**: C++17 with CMake build system
- **Platform**: macOS-focused (uses Objective-C++ for clipboard integration)
- **Dependencies**: Boost, Protobuf, Snappy, zipper, nanosvg
- **Current Build**: Basic CMake with arch-specific build.sh script
- **Existing Outputs**: svg2key CLI tool, static library
- **Missing**: Tests, version management, CI/CD, cross-platform releases

## Phase 1: Testing Infrastructure
### 1.1 Choose Testing Framework
- **Decision**: Catch2 v3 (modern, header-only in v2, good CMake integration)
- **Rationale**: Better for this project size, cleaner syntax, easier setup than Google Test

### 1.2 Test Structure Design
```
tests/
├── CMakeLists.txt
├── test_main.cpp
├── unit/
│   ├── test_svg_parser.cpp
│   ├── test_keynote_converter.cpp
│   └── test_protobuf_helpers.cpp
├── integration/
│   ├── test_svg_to_keynote.cpp
│   └── test_keynote_to_svg.cpp
└── fixtures/
    ├── sample.svg
    └── sample.key
```

### 1.3 Test Categories
- **Unit Tests**: Individual function/class testing
- **Integration Tests**: End-to-end conversion workflows
- **Regression Tests**: Prevent known issues from recurring

## Phase 2: Version Management System
### 2.1 Semantic Versioning Strategy
- **Format**: vX.Y.Z (e.g., v1.2.3)
- **Patch**: Bug fixes, documentation updates
- **Minor**: New features, backward-compatible changes
- **Major**: Breaking changes, API modifications

### 2.2 Version Embedding
- Generate version.hpp from git tags
- Embed version in binaries and library
- Add --version flag to CLI tools

### 2.3 Version Source Generation
```cpp
// Generated version.hpp
#pragma once
#define SVG2KEYNOTE_VERSION_MAJOR 1
#define SVG2KEYNOTE_VERSION_MINOR 2
#define SVG2KEYNOTE_VERSION_PATCH 3
#define SVG2KEYNOTE_VERSION_STRING "1.2.3"
#define SVG2KEYNOTE_BUILD_TYPE "Release"
#define SVG2KEYNOTE_BUILD_DATE "2025-01-17"
```

## Phase 3: Build System Enhancement
### 3.1 CMake Improvements
- Add version detection from git tags
- Integrate testing framework
- Support for multiplatform builds
- Add install targets

### 3.2 Local Scripts
- **build.sh**: Enhanced cross-platform build
- **test.sh**: Run all tests with coverage
- **release.sh**: Local release workflow
- **install.sh**: Installation helper

### 3.3 Build Matrix
- **Platforms**: macOS (x86_64, arm64), Linux (x86_64, arm64)
- **Configurations**: Debug, Release
- **Outputs**: Static library, CLI tools, tests

## Phase 4: GitHub Actions CI/CD
### 4.1 Workflow Structure
```
.github/workflows/
├── ci.yml          # PR and push testing
├── release.yml     # Tag-based releases
└── nightly.yml     # Nightly builds (optional)
```

### 4.2 CI Pipeline (ci.yml)
**Triggers**: Push to main, pull requests
**Jobs**:
1. **build-and-test**: Multi-platform build and test
2. **code-quality**: Format checking, static analysis
3. **coverage**: Code coverage reporting

### 4.3 Release Pipeline (release.yml)
**Triggers**: Git tags matching v*.*.*
**Jobs**:
1. **validate-tag**: Ensure proper semver format
2. **build-release**: Multi-platform release builds
3. **create-release**: GitHub release with artifacts
4. **publish-packages**: Package distribution (if needed)

## Phase 5: Multiplatform Support
### 5.1 Cross-compilation Strategy
- **macOS**: Native builds on GitHub Actions macOS runners
- **Linux**: Cross-compile or native builds
- **Windows**: Cross-compile from Linux (if feasible)

### 5.2 Dependency Management
- Static linking for portability
- Vendor critical dependencies
- Document system requirements

### 5.3 Artifact Strategy
- **Binary releases**: Compressed platform-specific archives
- **Source releases**: Tagged source code
- **Development builds**: Nightly/branch builds

## Phase 6: Release Automation
### 6.1 Release Process
1. **Development**: Work on feature branches
2. **Testing**: CI validates all changes
3. **Tagging**: Create semver git tag
4. **Automation**: GitHub Actions triggers release
5. **Distribution**: Artifacts published to GitHub Releases

### 6.2 Release Artifacts
```
Releases/
├── svg2keynote-v1.2.3-macos-x86_64.tar.gz
├── svg2keynote-v1.2.3-macos-arm64.tar.gz
├── svg2keynote-v1.2.3-linux-x86_64.tar.gz
├── svg2keynote-v1.2.3-linux-arm64.tar.gz
├── svg2keynote-v1.2.3-source.tar.gz
└── checksums.sha256
```

### 6.3 Installation Methods
- **Direct Download**: GitHub Releases
- **Package Managers**: Homebrew formula (future)
- **Build from Source**: Enhanced instructions

## Phase 7: Quality Assurance
### 7.1 Testing Strategy
- **Unit Tests**: 80%+ coverage goal
- **Integration Tests**: Key workflow validation
- **Performance Tests**: Regression detection
- **Platform Tests**: Cross-platform compatibility

### 7.2 Code Quality
- **Format**: clang-format integration
- **Linting**: Static analysis tools
- **Security**: Dependency scanning
- **Documentation**: API documentation generation

## Phase 8: Documentation Updates
### 8.1 User Documentation
- Update installation instructions
- Add release process documentation
- Include testing guide
- Version compatibility matrix

### 8.2 Developer Documentation
- Contributing guidelines
- Build system overview
- Release workflow documentation
- Testing strategy guide

## Implementation Timeline
### Week 1: Foundation
- Set up testing infrastructure
- Implement version management
- Create enhanced build scripts

### Week 2: CI/CD
- Implement GitHub Actions workflows
- Set up multiplatform builds
- Test release automation

### Week 3: Polish
- Add comprehensive tests
- Improve documentation
- Validate full workflow

## Success Criteria
- [ ] Comprehensive test suite with good coverage
- [ ] Automated semver-based releases from git tags
- [ ] Multiplatform binary distributions
- [ ] Streamlined local development workflow
- [ ] Robust CI/CD pipeline
- [ ] Clear installation and usage documentation

## Risk Mitigation
- **Dependency Issues**: Vendor critical dependencies
- **Platform Compatibility**: Extensive testing matrix
- **Breaking Changes**: Careful API versioning
- **Build Complexity**: Comprehensive documentation

## Future Enhancements
- Package manager integration (Homebrew, apt, etc.)
- Container-based distribution
- Plugin system for additional formats
- Performance benchmarking automation
