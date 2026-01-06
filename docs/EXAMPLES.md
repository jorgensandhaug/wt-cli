# Usage Examples

## Basic Workflow

### Starting work on a new feature

```bash
# Create a new worktree for your feature
wt new feature-auth

# This:
# 1. Creates branch 'feature-auth' from current HEAD
# 2. Creates worktree at ../yourrepo-feature-auth
# 3. Runs setup scripts from .cursor/worktrees.json
# 4. cd's you into the new worktree
# 5. Optionally runs configured command (e.g., opens editor)
```

### Working on an existing branch

```bash
# Checkout an existing remote branch into a worktree
wt new -b origin/feature-api

# This auto-fetches if the branch doesn't exist locally
```

### Reviewing a Pull Request

```bash
# Create a worktree from a GitHub PR (requires gh CLI)
wt new -p 123

# This:
# 1. Uses gh CLI to get the PR branch name
# 2. Fetches the branch
# 3. Creates worktree for the PR
# 4. cd's you into it
```

### Switching between worktrees

```bash
# List all worktrees with status
wt ls

# Output:
# main              ✓ clean, pushed
# feature-auth      ↑ 2 unpushed
# feature-api       ✗ dirty

# Switch to a worktree
wt cd feature-auth

# Go back to main worktree
wt cd
```

### Finishing work

```bash
# Remove the current worktree (after merging)
wt rm

# Or remove a specific worktree
wt rm feature-auth

# Force remove (ignores dirty/unpushed warnings)
wt rm -f feature-auth
```

## Cleanup

### Interactive cleanup

```bash
wt purge

# Shows each clean worktree and asks to remove
# Skips dirty/unpushed worktrees
```

### Clean stale references

```bash
wt prune

# Runs git worktree prune to clean up
```

## Multiple Features

```bash
# Work on auth feature
wt new feature-auth
# ... make changes, commit, push ...
wt cd main

# Work on API feature in parallel
wt new feature-api
# ... make changes ...
wt cd main

# See all worktrees
wt ls

# Clean up after merging
wt rm feature-auth
wt rm feature-api
```

## Project Setup Scripts

Create `.cursor/worktrees.json` in your project root:

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

Now when you run `wt new feature-x`:
1. npm dependencies are installed
2. Environment file is created

When you run `wt new -u feature-x` (or `wt up` later):
1. Setup commands run first
2. Docker services start
3. Dev server starts

When you run `wt down`:
1. Docker services stop

And `wt rm feature-x` runs cleanup before removal.
