# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Fish shell support

## [1.0.0] - 2025-01-06

### Added
- Initial release
- `wt new <branch>` - Create new worktree with new branch
- `wt new -b <branch>` - Create worktree from existing branch (auto-fetches)
- `wt new -p <pr>` - Create worktree from GitHub PR (requires gh CLI)
- `wt new -u <branch>` - Create worktree and run 'up' commands
- `wt ls` - List worktrees with colored status indicators
- `wt cd [name]` - Change directory to worktree (main if no name)
- `wt up` - Spin up dev environment (run 'up' commands from config)
- `wt down` - Spin down dev environment (run 'down' commands from config)
- `wt rm [-f] [name]` - Remove worktree (current if no name given)
- `wt purge` - Interactive cleanup of merged worktrees
- `wt prune` - Clean stale worktree references
- `wt config` - Show config file path
- `wt update` - Self-update from GitHub
- `wt version` - Show version
- Support for project-specific scripts via `.cursor/worktrees.json`:
  - `setup-worktree`: runs on worktree creation
  - `up`: runs with `wt up` or `wt new -u`
  - `down`: runs with `wt down`
  - `cleanup-worktree`: runs before worktree removal
- Colored output with NO_COLOR support
- Unknown command error message with help
- One-line installer: `curl -sSL ... | bash`
