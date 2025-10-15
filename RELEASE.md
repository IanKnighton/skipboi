# Release Process

This document describes how to create a new release of skipboi.

## Prerequisites

- Push access to the repository
- Ability to create tags

## Creating a Release

1. **Update version in code (if applicable)**
   
   Currently, skipboi doesn't have a version flag, so this step can be skipped. If you add one in the future, update it before tagging.

2. **Create and push a version tag**

   ```bash
   # Make sure you're on the main branch and up to date
   git checkout main
   git pull origin main
   
   # Create a new tag (use semantic versioning: vMAJOR.MINOR.PATCH)
   git tag -a v1.0.0 -m "Release version 1.0.0"
   
   # Push the tag to GitHub
   git push origin v1.0.0
   ```

3. **Automated process**

   Once you push the tag, GitHub Actions will automatically:
   - Build the release binary
   - Create a GitHub Release with the binary and checksums
   - Update the Homebrew formula with the new version and SHA256

4. **Verify the release**

   - Check that the GitHub Release was created: https://github.com/IanKnighton/skipboi/releases
   - Verify the Homebrew formula was updated in the homebrew-tap repository
   - Test the installation:
     ```bash
     brew tap IanKnighton/homebrew-tap
     brew install skipboi
     skipboi help
     ```

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for added functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

Examples:
- `v1.0.0` - Initial stable release
- `v1.1.0` - Added new command
- `v1.0.1` - Bug fix

## Troubleshooting

### GitHub Actions workflow fails

- Check the Actions tab for error details
- Common issues:
  - Swift version mismatch (update `.github/workflows/release.yml`)
  - Build errors (test locally with `swift build -c release`)
  - Permission issues (check repository settings)

### Homebrew formula not updating

- Check if the `update-formula` job completed successfully
- Verify the SHA256 was calculated correctly
- The formula update may take a few minutes after the release is created

### Users can't install via Homebrew

- Check if the tap exists: `brew tap-info IanKnighton/homebrew-tap`
- Verify the formula syntax: `brew audit --strict Formula/skipboi.rb`
- Test installation in a clean environment

## Manual Formula Update

If the automatic update fails, you can update the formula manually:

```bash
# Calculate the SHA256 of the source tarball
curl -sL https://github.com/IanKnighton/skipboi/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256

# Update Formula/skipboi.rb with the new version and SHA256
# Commit and push to main branch
git add Formula/skipboi.rb
git commit -m "Update Homebrew formula for v1.0.0"
git push origin main
```

Note: This step should be done in the `IanKnighton/homebrew-tap` repository.

## Release Checklist

- [ ] Code is tested and working on macOS
- [ ] Version tag follows semantic versioning
- [ ] Tag is pushed to GitHub
- [ ] GitHub Actions workflow completes successfully
- [ ] GitHub Release is created with binaries
- [ ] Homebrew formula is updated
- [ ] Installation via Homebrew is tested
- [ ] Release notes are clear and informative
