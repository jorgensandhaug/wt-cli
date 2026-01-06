# Configuration

## Global Configuration

wt-cli stores its configuration at `~/.config/wt/config.json` (or `$XDG_CONFIG_HOME/wt/config.json`).

### Options

```json
{
  "command": "claude --dangerously-skip-permissions"
}
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `command` | string | `""` | Command to run after creating a new worktree |

### Example Configurations

**Run Claude Code in new worktrees:**
```json
{
  "command": "claude --dangerously-skip-permissions"
}
```

**Open VS Code in new worktrees:**
```json
{
  "command": "code ."
}
```

**No automatic command:**
```json
{
  "command": ""
}
```

## Project Configuration

Projects can define worktree-specific scripts in `.cursor/worktrees.json`:

```json
{
  "setup-worktree": [
    "npm install",
    "cp .env.example .env"
  ],
  "up": [
    "docker-compose up -d",
    "npm run dev &"
  ],
  "down": [
    "docker-compose down"
  ],
  "cleanup-worktree": [
    "rm -rf node_modules"
  ]
}
```

### setup-worktree

Array of commands run after creating a worktree (always). Useful for:
- Installing dependencies
- Setting up environment files

### up

Array of commands run with `wt up` or `wt new -u`. Useful for:
- Starting Docker containers
- Starting dev servers
- Opening editors

### down

Array of commands run with `wt down`. Useful for:
- Stopping Docker containers
- Stopping dev servers

### cleanup-worktree

Array of commands run before removing a worktree (always). Useful for:
- Cleaning up build artifacts
- Removing generated files

## Environment Variables

| Variable | Description |
|----------|-------------|
| `NO_COLOR` | Disable colored output (see https://no-color.org/) |
| `XDG_CONFIG_HOME` | Override default config directory |
