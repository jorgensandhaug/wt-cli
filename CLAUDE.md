# wt-cli Development Guide

## Overview

Git worktree management CLI. Single file shell script (`wt.sh`) that works in bash/zsh.

## Testing

```bash
# Run full test suite (33 tests)
bash tests/test_runner.sh

# Manual testing - use the dummy repo
cd /Users/jorgensandhaug/Documents/wt-test-dummy
source /Users/jorgensandhaug/Documents/wt-cli/wt.sh
wt new test-branch
wt ls
wt rm test-branch
```


## Directory Structure

Worktrees are created at `../.worktrees/reponame/branchname/`:
```
parent/
  myrepo/
  .worktrees/
    myrepo/
      feature-x/
      bugfix/auth/
```

## Key Functions in wt.sh

- `_wt_new()` - Creates worktrees, handles -b (existing branch), -p (PR), -u (run up commands)
- `_wt_find_worktree()` - Resolves worktree name or path to full path
- `_wt_get_status()` - Single git command for dirty/unpushed check (performance optimized)
- `_wt_ls()` - Lists worktrees with status
- `_wt_rm()` - Removes worktree with safety checks

## Shell Quirks

zsh has issues with `local` variable declaration in pipelines. Use:
```bash
local var=""
var="$(command)"
```

Not:
```bash
local var="$(command)"  # Can leak debug output in zsh
```

## After Making Changes

1. Run tests: `bash tests/test_runner.sh`
2. Test manually in dummy repo
3. Update local install: `cp wt.sh ~/.wt/wt.sh`

## Style

- Keep documentation clean and professional
- No unnecessary comments in code
- No tab completion (Warp terminal overrides it)
- Status indicators: `[ok]`, `[dirty]`, `[unpushed]`
