# wt-cli

Git worktree management CLI with colored status and Claude integration.

[![Tests](https://github.com/jorgensandhaug/wt-cli/actions/workflows/test.yml/badge.svg)](https://github.com/jorgensandhaug/wt-cli/actions/workflows/test.yml)

## Install

```bash
curl -sSL https://raw.githubusercontent.com/jorgensandhaug/wt-cli/main/install.sh | bash
```

### Requirements

- `git`
- `jq` (`brew install jq` on macOS, `apt install jq` on Ubuntu)
- bash or zsh

### Uninstall

```bash
curl -sSL https://raw.githubusercontent.com/jorgensandhaug/wt-cli/main/uninstall.sh | bash
```

## Commands

| Command | Description |
|---------|-------------|
| `wt new <branch>` | Create new worktree with new branch |
| `wt new -b <branch>` | Create worktree from existing branch (auto-fetches) |
| `wt new -p <pr>` | Create worktree from GitHub PR (requires gh CLI) |
| `wt new -u <branch>` | Create worktree and run 'up' commands |
| `wt ls` | List all worktrees with colored status |
| `wt cd [name]` | cd to worktree (main if no name) |
| `wt up` | Spin up dev environment (run 'up' commands) |
| `wt down` | Spin down dev environment (run 'down' commands) |
| `wt rm [name]` | Remove worktree (current if no name given) |
| `wt rm -f [name]` | Force remove (ignores dirty/unpushed warnings) |
| `wt purge` | Interactive cleanup of clean worktrees |
| `wt prune` | Clean stale worktree references |
| `wt config` | Show config file path |
| `wt update` | Self-update to latest version |
| `wt version` | Show version |

## Directory Structure

```
parent/
  myrepo/
  .worktrees/
    myrepo/
      feature-x/
      bugfix/login/
```

## Status Indicators

`wt ls` shows status:

- `[ok]` - Clean and pushed
- `[unpushed]` - Has unpushed commits
- `[dirty]` - Has uncommitted changes

## Configuration

### User Config

`~/.config/wt/config.json`:

```json
{
  "command": "claude --dangerously-skip-permissions"
}
```

The `command` runs after creating a new worktree.

### Project Config

`.cursor/worktrees.json`:

```json
{
  "setup-worktree": ["npm install", "cp .env.example .env"],
  "up": ["docker-compose up -d", "npm run dev &"],
  "down": ["docker-compose down"],
  "cleanup-worktree": ["rm -rf node_modules"]
}
```

- `setup-worktree`: Runs after creating worktree (always)
- `up`: Runs with `wt up` or `wt new -u` (spin up services)
- `down`: Runs with `wt down` (spin down services)
- `cleanup-worktree`: Runs before removing worktree (always)

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md) for details.

## Example Workflow

```bash
# Start a new feature
wt new auth-refactor

# Start a feature and spin up dev environment
wt new -u auth-refactor

# Work on an existing remote branch
wt new -b origin/feature-api

# Review a PR
wt new -p 123

# See all worktrees
wt ls

# Switch worktrees
wt cd feature-api

# Go back to main
wt cd

# Spin up dev environment
wt up

# Spin down dev environment
wt down

# Done with feature - remove current worktree
wt rm

# Clean up all finished worktrees
wt purge

# Update wt-cli
wt update
```

See [docs/EXAMPLES.md](docs/EXAMPLES.md) for more examples.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
