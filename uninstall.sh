#!/usr/bin/env bash
# wt-cli uninstaller

set -e

WT_DIR="$HOME/.wt"
WT_SH="$WT_DIR/wt.sh"

echo "Uninstalling wt-cli..."

# Remove source lines from shell configs
remove_source_line() {
  local file="$1"

  if [[ -f "$file" ]]; then
    # Remove the source line and the comment above it
    if grep -qF "source \"$WT_SH\"" "$file"; then
      # Create temp file without wt lines
      grep -v "# wt-cli" "$file" | grep -v "source \"$WT_SH\"" > "$file.tmp"
      mv "$file.tmp" "$file"
      echo "Removed source line from $file"
    fi
  fi
}

remove_source_line "$HOME/.zshrc"
remove_source_line "$HOME/.bashrc"

# Remove fish config (requires different handling - multi-line block)
fish_config="$HOME/.config/fish/config.fish"
if [[ -f "$fish_config" ]] && grep -qF "# wt-cli" "$fish_config"; then
  sed '/# wt-cli/,/^end$/d' "$fish_config" > "$fish_config.tmp"
  mv "$fish_config.tmp" "$fish_config"
  echo "Removed wt-cli from $fish_config"
fi

# Remove wt directory
if [[ -d "$WT_DIR" ]]; then
  rm -rf "$WT_DIR"
  echo "Removed $WT_DIR"
fi

echo ""
echo "wt-cli uninstalled successfully!"
echo "Note: Config at ~/.config/wt/ was preserved. Remove manually if desired."
echo ""
