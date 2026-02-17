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

# Download zsh completions
echo "Downloading zsh completions..."
mkdir -p "$WT_DIR/completions"
curl -sSL "$BASE_URL/completions/_wt" -o "$WT_DIR/completions/_wt"

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

# Add to fish config
if [[ -f "$HOME/.config/fish/config.fish" ]] || [[ "$SHELL" == *fish* ]]; then
  fish_config="$HOME/.config/fish/config.fish"

  mkdir -p "$HOME/.config/fish"
  touch "$fish_config"

  if ! grep -qF "# wt-cli" "$fish_config"; then
    {
      echo ""
      echo "# wt-cli"
      echo "# The wt.sh script is written in bash. Fish cannot source bash scripts directly,"
      echo "# so we run it in a bash subprocess. However, process state changes (like cd) in"
      echo "# a subprocess don't affect the parent fish shell. To work around this, we capture"
      echo "# bash's final working directory and do the cd in fish."
      echo "function wt"
      echo "    set -l tmpfile (mktemp)"
      echo "    bash -c 'source \"\$HOME/.wt/wt.sh\" && _wt_main \"\$@\" && echo \"\$PWD\" > \"'\"\$tmpfile\"'\"' -- \$argv"
      echo "    set -l exit_code \$status"
      echo "    set -l new_dir (cat \$tmpfile)"
      echo "    rm -f \$tmpfile"
      echo "    if test -n \"\$new_dir\" -a -d \"\$new_dir\" -a \"\$new_dir\" != \"\$PWD\""
      echo "        cd \$new_dir"
      echo "    end"
      echo "    return \$exit_code"
      echo "end"
    } >> "$fish_config"
    echo "Added wt-cli to $fish_config"
  else
    echo "wt-cli already in $fish_config"
  fi
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
