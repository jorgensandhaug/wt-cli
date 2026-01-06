# Contributing to wt-cli

Thank you for your interest in contributing to wt-cli!

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/jorgensandhaug/wt-cli.git
   cd wt-cli
   ```

2. Source the script for local development:
   ```bash
   source ./wt.sh
   ```

3. Run tests:
   ```bash
   bash tests/test_runner.sh
   ```

## Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```

2. Make your changes to `wt.sh`

3. Add tests in `tests/test_*.sh`

4. Run the test suite to verify:
   ```bash
   bash tests/test_runner.sh
   ```

5. Test in both bash and zsh if possible

## Code Style

- Use `_wt_` prefix for internal functions
- Use lowercase with underscores for variable names
- Avoid zsh reserved words as variable names (`status`, `path`, etc.)
- Support both bash and zsh
- Respect `NO_COLOR` environment variable

## Pull Request Process

1. Update documentation if adding features
2. Add tests for new functionality
3. Ensure all tests pass
4. Update CHANGELOG.md with your changes

## Reporting Issues

When reporting issues, please include:
- Your shell (bash/zsh) and version
- Your OS (macOS/Linux)
- Steps to reproduce
- Expected vs actual behavior
