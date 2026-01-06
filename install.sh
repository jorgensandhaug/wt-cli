#!/usr/bin/env bash
# wt-cli installer
# Usage: curl -sSL https://raw.githubusercontent.com/jorgensandhaug/wt-cli/main/install.sh | bash

set -e

WT_DIR="$HOME/.wt"
WT_SH="$WT_DIR/wt.sh"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wt"
CONFIG_FILE="$CONFIG_DIR/config.json"
BASE_URL="https://raw.githubusercontent.com/jorgensandhaug/wt-cli/main"

echo "Installing wt-cli..."

# Check dependencies
if ! command -v git &>/dev/null; then
  echo "Error: git is required but not installed."
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed."
  echo "  macOS: brew install jq"
  echo "  Ubuntu: apt install jq"
  exit 1
fi

# Create directory
mkdir -p "$WT_DIR"

# Download main script
echo "Downloading wt.sh..."
curl -sSL "$BASE_URL/wt.sh" -o "$WT_SH"
chmod +x "$WT_SH"

# Create default config
if [[ ! -f "$CONFIG_FILE" ]]; then
  mkdir -p "$CONFIG_DIR"
  echo '{"command": "claude --dangerously-skip-permissions"}' > "$CONFIG_FILE"
  echo "Created config at $CONFIG_FILE"
fi

# Add source line to shell configs
add_to_shell_config() {
  local file="$1"
  local source_line="source \"$WT_SH\""

  touch "$file"

  if ! grep -qF "$source_line" "$file"; then
    {
      echo ""
      echo "# wt-cli"
      echo "$source_line"
    } >> "$file"
    echo "Added wt-cli to $file"
  else
    echo "wt-cli already in $file"
  fi
}

# Add to zshrc
if [[ -f "$HOME/.zshrc" ]] || [[ "$SHELL" == *zsh* ]]; then
  add_to_shell_config "$HOME/.zshrc"
fi

# Add to bashrc
if [[ -f "$HOME/.bashrc" ]] || [[ "$SHELL" == *bash* ]]; then
  add_to_shell_config "$HOME/.bashrc"
fi

echo ""
echo "wt-cli installed successfully!"
echo ""
echo "Usage:"
echo "  wt new <branch>      Create new worktree with new branch"
echo "  wt new -b <branch>   Create worktree from existing branch"
echo "  wt new -p <pr>       Create worktree from GitHub PR"
echo "  wt new -u <branch>   Create worktree and run 'up' commands"
echo "  wt ls                List worktrees with status"
echo "  wt cd [name]         cd to worktree (main if no name)"
echo "  wt up                Spin up dev environment"
echo "  wt down              Spin down dev environment"
echo "  wt rm [name]         Remove worktree (current if no name)"
echo "  wt purge             Interactive cleanup"
echo "  wt prune             Clean stale refs"
echo "  wt update            Update to latest version"
echo "  wt config            Show config path"
