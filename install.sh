#!/bin/bash
# install.sh — install the packages, write theme.ini into the configs, link them into place.
# Safe to re-run. Whatever a link would replace is moved aside first, as <name>.bak-<time>.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$REPO/build"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "==> Installing packages from Brewfile"
brew bundle --file="$REPO/Brewfile" || \
  echo "    (background-music needs your password; run brew bundle in your own terminal to finish)"

echo "==> Writing theme.ini into the configs"
"$REPO/bin/render"

# link <file or folder under build/> <where its tool looks for it>
link() {
  local src="$BUILD/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "    moving aside $dest -> $dest.bak-$STAMP"
    mv "$dest" "$dest.bak-$STAMP"
  fi
  ln -sfn "$src" "$dest"
  echo "    $dest"
}

echo "==> Linking the configs"
for tool in aerospace sketchybar borders ghostty fastfetch btop; do
  link "$tool" "$HOME/.config/$tool"
done
link starship/starship.toml  "$HOME/.config/starship.toml"
link cava/config             "$HOME/.config/cava/config"   # cava keeps its own shaders in that folder
link vim/vimrc               "$HOME/.vimrc"
link vim/colors              "$HOME/.vim/colors"
link vim/plugin              "$HOME/.vim/plugin"
link matplotlib/matplotlibrc "$HOME/.matplotlib/matplotlibrc"

# vim loads anything under ~/.vim/pack/*/start on its own; lexima closes brackets and quotes
if [ ! -d "$HOME/.vim/pack/plugins/start/lexima.vim" ]; then
  echo "==> Installing the vim plugin lexima"
  mkdir -p "$HOME/.vim/pack/plugins/start"
  # Pinned: Vim runs whatever is in that folder, so not simply the newest commit.
  git clone --quiet https://github.com/cohama/lexima.vim "$HOME/.vim/pack/plugins/start/lexima.vim"
  git -C "$HOME/.vim/pack/plugins/start/lexima.vim" checkout --quiet 9f6942c5e1f0f6fe63bdcdac515f34c484b970f5
fi

# Saving a Python file formats it with ruff, offline (see rice_format.vim): fetch ruff once here.
uvx ruff --version >/dev/null 2>&1 || echo "    (could not fetch ruff; Python files will be saved unformatted)"

echo "==> Sourcing the rice from ~/.zshrc (prompt, plugins, window titles, plot windows)"
if ! grep -qF "$BUILD/zsh/rice.zsh" "$HOME/.zshrc" 2>/dev/null; then
  # The repo has moved: drop the line that points at where it was.
  if grep -q '# macos-rice$' "$HOME/.zshrc" 2>/dev/null; then
    kept="$(grep -v '# macos-rice$' "$HOME/.zshrc" || true)"
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"
    printf '%s\n' "$kept" > "$HOME/.zshrc"
  fi
  echo "source \"$BUILD/zsh/rice.zsh\"   # macos-rice" >> "$HOME/.zshrc"
  echo "    added one line to ~/.zshrc"
fi

echo "==> Silencing the 'Last login' banner (~/.hushlogin)"
touch "$HOME/.hushlogin"

echo "==> Hiding native menu bar so SketchyBar is visible"
defaults write NSGlobalDomain _HIHideMenuBar -bool true

echo "==> Starting services"
brew services start sketchybar 2>/dev/null || sketchybar --reload || true
brew services start borders 2>/dev/null || true

echo ""
echo "Done. Final manual step: open AeroSpace.app once and grant Accessibility"
echo "permission (System Settings > Privacy & Security > Accessibility)."
echo "After a change to theme.ini or config/:  bin/apply"
