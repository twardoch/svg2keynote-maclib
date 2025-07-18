# TODO

## Phase 1: Testing Infrastructure
- [ ] Install and configure Catch2 testing framework
- [ ] Create tests/ directory structure
- [ ] Add test_main.cpp with Catch2 integration
- [ ] Create CMakeLists.txt for tests
- [ ] Add unit tests for SVG parser functionality
- [ ] Add unit tests for Keynote converter functionality
- [ ] Add unit tests for protobuf helpers
- [ ] Add integration tests for SVG to Keynote conversion
- [ ] Add integration tests for Keynote to SVG conversion
- [ ] Create test fixtures (sample.svg, sample.key)
- [ ] Integrate tests into main CMakeLists.txt

## Phase 2: Version Management System
- [ ] Create version detection from git tags in CMake
- [ ] Generate version.hpp header file
- [ ] Embed version information in binaries
- [ ] Add --version flag to svg2key CLI tool
- [ ] Add --version flag to keynote CLI tool
- [ ] Create version validation script
- [ ] Test version embedding with sample git tags

## Phase 3: Build System Enhancement
- [ ] Enhance CMakeLists.txt with version detection
- [ ] Add multiplatform build support
- [ ] Create install targets for CMake
- [ ] Enhance build.sh for cross-platform support
- [ ] Create test.sh script for running tests
- [ ] Create release.sh script for local releases
- [ ] Create install.sh helper script
- [ ] Add build configuration matrix support

## Phase 4: GitHub Actions CI/CD
- [ ] Create .github/workflows directory
- [ ] Implement ci.yml workflow for PR/push testing
- [ ] Implement release.yml workflow for tag-based releases
- [ ] Add build-and-test job for multiple platforms
- [ ] Add code-quality job with formatting checks
- [ ] Add coverage reporting job
- [ ] Add validate-tag job for semver compliance
- [ ] Add build-release job for multiplatform builds
- [ ] Add create-release job for GitHub releases
- [ ] Test workflows with sample tags

## Phase 5: Multiplatform Support
- [ ] Configure macOS x86_64 builds
- [ ] Configure macOS arm64 builds
- [ ] Configure Linux x86_64 builds
- [ ] Configure Linux arm64 builds
- [ ] Set up static linking for portability
- [ ] Document system requirements
- [ ] Create platform-specific build scripts
- [ ] Test cross-compilation setup

## Phase 6: Release Automation
- [ ] Define release artifact naming convention
- [ ] Create artifact packaging scripts
- [ ] Set up checksums generation
- [ ] Configure GitHub Releases integration
- [ ] Test complete release workflow
- [ ] Document release process
- [ ] Create release validation checklist

## Phase 7: Quality Assurance
- [ ] Set up code coverage measurement
- [ ] Add performance regression tests
- [ ] Configure static analysis tools
- [ ] Add security scanning
- [ ] Create code formatting configuration
- [ ] Add documentation generation
- [ ] Validate cross-platform compatibility

## Phase 8: Documentation Updates
- [ ] Update README.md with new installation methods
- [ ] Add testing guide documentation
- [ ] Create contributing guidelines
- [ ] Document build system overview
- [ ] Create release workflow documentation
- [ ] Add version compatibility matrix
- [ ] Update example usage sections
