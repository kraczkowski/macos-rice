#!/bin/bash
# install.sh — symlink configs into ~/.config and install packages.
# Idempotent: safe to re-run. Backs up anything it would overwrite.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "==> Installing packages from Brewfile"
brew bundle --file="$REPO/Brewfile" || \
  echo "    (some casks like sf-symbols need sudo; run brew bundle in your own terminal to finish)"

echo "==> Linking configs into $CONFIG"
mkdir -p "$CONFIG"

link() {
  local src="$REPO/config/$1"
  local dest="$CONFIG/$1"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "    backing up existing $dest -> $dest.bak-$STAMP"
    mv "$dest" "$dest.bak-$STAMP"
  fi
  ln -sfn "$src" "$dest"
  echo "    linked $1"
}

link aerospace
link sketchybar
link borders
link ghostty
# starship lives at ~/.config/starship.toml (single file)
ln -sfn "$REPO/config/starship/starship.toml" "$CONFIG/starship.toml"
echo "    linked starship.toml"

echo "==> Making scripts executable"
chmod +x "$REPO"/config/sketchybar/sketchybarrc \
         "$REPO"/config/sketchybar/plugins/*.sh \
         "$REPO"/config/borders/bordersrc

echo "==> Enabling starship in your shell (~/.zshrc)"
if ! grep -q 'starship init zsh' "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
  echo "    added starship init to ~/.zshrc"
else
  echo "    starship already in ~/.zshrc"
fi

echo "==> Hiding native menu bar so SketchyBar is visible"
defaults write NSGlobalDomain _HIHideMenuBar -bool true

echo "==> Starting services"
brew services start sketchybar 2>/dev/null || sketchybar --reload
brew services start borders 2>/dev/null || true

echo ""
echo "Done. Final manual step: open AeroSpace.app once and grant Accessibility"
echo "permission (System Settings > Privacy & Security > Accessibility)."
