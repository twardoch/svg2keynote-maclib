# GitHub Actions Setup Instructions

Due to GitHub App permissions, the workflow files need to be manually added to enable CI/CD automation. Follow these steps:

## Step 1: Add GitHub Actions Workflows

Create the following directory structure in your repository:
```
.github/
└── workflows/
    ├── ci.yml
    └── release.yml
```

### CI Workflow (`.github/workflows/ci.yml`)

This workflow runs on every push and pull request to test the code across multiple platforms.

**Copy the content from**: `/root/repo/.github/workflows/ci.yml`

**Key features:**
- Multi-platform builds (Ubuntu, macOS)
- Multiple build configurations (Debug, Release)
- Automated testing with Catch2
- Code quality checks
- Coverage reporting
- Build artifact uploads

### Release Workflow (`.github/workflows/release.yml`)

This workflow creates GitHub releases when you push semantic version tags.

**Copy the content from**: `/root/repo/.github/workflows/release.yml`

**Key features:**
- Triggered by semantic version tags (v1.0.0, v1.2.3-beta, etc.)
- Multi-platform release builds
- Automated GitHub release creation
- Release asset packaging with checksums
- Proper release notes generation

## Step 2: Enable GitHub Actions

1. Go to your repository on GitHub
2. Click the "Actions" tab
3. If prompted, click "I understand my workflows, go ahead and enable them"
4. The workflows will appear and be ready to run

## Step 3: Test the Setup

### Test CI Workflow
1. Create a pull request or push to main/develop branch
2. The CI workflow should automatically run
3. Check the "Actions" tab to see the build and test results

### Test Release Workflow
1. Create a semantic version tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
2. The release workflow should automatically:
   - Build for all platforms
   - Create a GitHub release
   - Upload release artifacts

## Step 4: Repository Settings

### Required Permissions
Ensure your repository has the following permissions enabled:
- Actions: Read and write
- Contents: Read and write
- Metadata: Read
- Pull requests: Read and write

### Branch Protection (Optional but Recommended)
For production use, consider adding branch protection rules:
1. Go to Settings → Branches
2. Add rule for `main` branch
3. Enable "Require status checks to pass before merging"
4. Select the CI workflow checks

## Usage Examples

### For Users
```bash
# Install latest version
curl -sSL https://raw.githubusercontent.com/your-repo/svg2keynote-lib/main/install.sh | bash

# Install specific version
curl -sSL https://raw.githubusercontent.com/your-repo/svg2keynote-lib/main/install.sh | bash -s /usr/local v1.0.0
```

### For Developers
```bash
# Build and test locally
./build.sh Debug
./test.sh

# Create a release
git tag v1.0.0
git push origin v1.0.0
```

## Troubleshooting

### Common Issues

1. **Workflow not running**: Check that the files are in the correct location (`.github/workflows/`)
2. **Permission errors**: Ensure Actions are enabled in repository settings
3. **Build failures**: Check the dependency installation steps match your system
4. **Release creation fails**: Verify the tag follows semantic versioning (v1.0.0)

### Debug Steps

1. Check the Actions tab for detailed logs
2. Verify all dependencies are properly installed
3. Test build scripts locally first
4. Check that all required files exist in the repository

## Advanced Configuration

### Customizing Platforms
Edit the matrix in `ci.yml` and `release.yml` to add or remove platforms:
```yaml
strategy:
  matrix:
    include:
      - os: ubuntu-latest
        platform: linux
      - os: macos-latest
        platform: darwin
      - os: windows-latest  # Add Windows support
        platform: windows
```

### Adding More Tests
Add additional test jobs in `ci.yml`:
```yaml
  integration-tests:
    runs-on: ubuntu-latest
    steps:
      # Add integration test steps
```

### Custom Release Notes
Modify the release notes generation in `release.yml`:
```yaml
- name: Generate release notes
  run: |
    # Add custom release notes logic
```

## Security Considerations

1. **Secrets Management**: Use GitHub Secrets for sensitive data
2. **Dependency Security**: Regularly update dependencies
3. **Permission Scope**: Use minimal required permissions
4. **Code Scanning**: Consider adding security scanning workflows

## Support

If you encounter issues:
1. Check the GitHub Actions documentation
2. Review the workflow logs in the Actions tab
3. Verify all dependencies are correctly installed
4. Test the build scripts locally first