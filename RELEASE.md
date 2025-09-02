# Release Procedures

This document outlines the procedures for releasing new versions of SimpleSpec.

## Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions  
- **PATCH** version for backwards-compatible bug fixes

## Release Types

### 1. Automated Release (Recommended) 🤖

The preferred method using GitHub Actions for consistency and security.

#### Steps:

1. **Update Version Numbers**
   ```bash
   # Update version in both files:
   # - simplespec/__init__.py
   # - pyproject.toml
   ```

2. **Update CHANGELOG.md**
   ```markdown
   ## [X.Y.Z] - YYYY-MM-DD
   
   ### Added
   - New features
   
   ### Changed  
   - Changes in existing functionality
   
   ### Fixed
   - Bug fixes
   
   ### Removed
   - Removed features
   ```

3. **Commit and Push Changes**
   ```bash
   git add simplespec/__init__.py pyproject.toml CHANGELOG.md
   git commit -m "Bump version to X.Y.Z"
   git push origin main
   ```

4. **Create and Push Tag**
   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

5. **Monitor Release**
   - Go to GitHub Actions tab
   - Watch the "Release" workflow
   - Verify success on [PyPI](https://pypi.org/project/simplespec/)

#### What the GitHub Action Does:
- ✅ Runs all tests on Python 3.11 and 3.12
- ✅ Builds the package
- ✅ Publishes to PyPI using environment secrets
- ✅ Creates GitHub release (if configured)

### 2. Manual Release 🔧

For development testing or when GitHub Actions is unavailable.

#### Prerequisites:
- `PYPI_API_TOKEN` environment variable set
- All tests passing locally

#### Steps:

1. **Run Pre-release Checks**
   ```bash
   # Run full test suite
   make check-all
   
   # Or manually:
   uv run pytest
   uv run ruff check
   uv run ruff format --check
   uv run mypy simplespec
   ```

2. **Update Version and Changelog** (same as automated)

3. **Use Publish Script**
   ```bash
   ./publish.sh
   ```
   
   This script will:
   - Validate your token
   - Run tests
   - Build the package
   - Ask for confirmation
   - Upload to PyPI

4. **Alternative: Manual Commands**
   ```bash
   # Clean and build
   rm -rf dist/
   uv build
   
   # Validate package
   uv run twine check dist/*
   
   # Upload to PyPI
   uv run twine upload dist/* --username __token__ --password $PYPI_API_TOKEN
   ```

## Setting Up PyPI Token

### For GitHub Codespaces:
1. Go to GitHub Settings → Codespaces → Repository secrets
2. Add `PYPI_API_TOKEN` with your PyPI token
3. Restart Codespaces

### For GitHub Actions:
1. Go to Repository Settings → Environments
2. Create/edit the `publish` environment  
3. Add secret: `PYPI_API_TOKEN`

### For Local Development:
```bash
# Option 1: Environment variable (temporary)
export PYPI_API_TOKEN="pypi-your-token-here"

# Option 2: Secure file (persistent)
echo "pypi-your-token-here" > ~/.pypi_token
chmod 600 ~/.pypi_token
export PYPI_API_TOKEN=$(cat ~/.pypi_token)
```

## Pre-release Checklist

Before any release:

- [ ] All tests pass (`uv run pytest`)
- [ ] Code is formatted (`uv run ruff format`)
- [ ] No linting errors (`uv run ruff check`)
- [ ] Type checking passes (`uv run mypy simplespec`)
- [ ] Version updated in `simplespec/__init__.py`
- [ ] Version updated in `pyproject.toml`
- [ ] `CHANGELOG.md` updated with new version
- [ ] Documentation is up to date
- [ ] Example code works with new version

## Post-release Checklist

After successful release:

- [ ] Verify package on [PyPI](https://pypi.org/project/simplespec/)
- [ ] Test installation: `pip install simplespec==X.Y.Z`
- [ ] Test basic functionality in fresh environment
- [ ] Update README badges if needed
- [ ] Announce release (if major/minor version)

## Troubleshooting

### Common Issues:

1. **Token Authentication Failed**
   ```
   Solution: Verify PYPI_API_TOKEN is set correctly
   Check: echo ${PYPI_API_TOKEN:0:10}  # Should show "pypi-AgEI..."
   ```

2. **Version Already Exists on PyPI**
   ```
   Solution: Bump version number and re-release
   PyPI doesn't allow overwriting existing versions
   ```

3. **Tests Fail Before Release**
   ```
   Solution: Fix failing tests before proceeding
   Never release with failing tests
   ```

4. **GitHub Action Fails**
   ```
   Solutions:
   - Check if PYPI_API_TOKEN secret is set in publish environment
   - Verify workflow has permission to access environment
   - Check logs in GitHub Actions tab
   ```

5. **Package Import Issues After Release**
   ```
   Solutions:
   - Wait a few minutes (PyPI needs time to propagate)
   - Clear pip cache: pip cache purge
   - Test in fresh virtual environment
   ```

## Emergency Procedures

### If Bad Release is Published:
1. **Don't panic** - PyPI versions are immutable
2. **Immediately release a patch version** with fixes
3. **Update documentation** to warn about the problematic version
4. **Consider yanking** the release on PyPI (makes it unavailable for new installs)

### Yanking a Release:
```bash
# Only if absolutely necessary
uv run twine upload --repository pypi --skip-existing dist/*
# Then manually yank on PyPI web interface
```

## Automation Improvements

Future enhancements to consider:
- [ ] Automatic CHANGELOG generation from commit messages
- [ ] GitHub Release creation with release notes
- [ ] Automated documentation deployment
- [ ] Release candidate (rc) versions for testing
- [ ] Integration with dependency update bots

## Contact

For release-related questions:
- Create an issue on GitHub
- Check existing GitHub Actions workflows
- Review this documentation
