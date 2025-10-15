# Homebrew Formula Location

The Homebrew formula for skipboi is maintained in the [IanKnighton/homebrew-tap](https://github.com/IanKnighton/homebrew-tap) repository.

When a new release is created (by pushing a version tag like `v1.0.0`), the GitHub Actions workflow in this repository automatically updates the formula in the homebrew-tap repository.

## Installation

Users can install skipboi using:

```bash
brew tap IanKnighton/homebrew-tap
brew install skipboi
```

## Formula Maintenance

The formula is automatically updated when:
1. A new version tag is pushed to this repository
2. The release workflow builds the binary and creates a GitHub Release
3. The workflow calculates the SHA256 of the source tarball
4. The workflow clones the homebrew-tap repository
5. Updates the formula with the new version and SHA256
6. Commits and pushes the changes back to homebrew-tap

For more details, see [RELEASE.md](RELEASE.md) and [HOMEBREW_IMPLEMENTATION.md](HOMEBREW_IMPLEMENTATION.md).
