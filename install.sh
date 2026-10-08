#!/bin/bash
# install.sh — install the packages, write theme.ini into the configs, link them into place.
# Safe to re-run. Whatever a link would replace is moved aside first, as <name>.bak-<time>.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$REPO/build"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "==> Installing packages from Brewfile"
brew bundle --file="$REPO/Brewfile"

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
link vim/vimrc               "$HOME/.vimrc"
link vim/colors              "$HOME/.vim/colors"
link vim/plugin              "$HOME/.vim/plugin"
link matplotlib/matplotlibrc "$HOME/.matplotlib/matplotlibrc"
link spotify-player/app.toml   "$HOME/.config/spotify-player/app.toml"   # files, not the folder: the client id lives beside them
link spotify-player/theme.toml "$HOME/.config/spotify-player/theme.toml"

echo "==> Linking the app themes"
link discord/sunset_ember.theme.css "$HOME/Library/Application Support/vesktop/themes/sunset_ember.theme.css"
link spicetify/Themes/SunsetEmber   "$HOME/.config/spicetify/Themes/SunsetEmber"
link qbittorrent/config.json        "$HOME/.config/qBittorrent/themes/default/config.json"   # its built-in theme, overridden

# Obsidian keeps its snippets per vault, and lists its vaults in obsidian.json. Without Obsidian
# there is no such file, and a vault that was deleted stays on the list: neither stops the install.
VAULTS="$HOME/Library/Application Support/obsidian/obsidian.json"
if [ -f "$VAULTS" ]; then
  python3 -c 'import json, sys; [print(v["path"]) for v in json.load(open(sys.argv[1])).get("vaults", {}).values()]' "$VAULTS" |
  while read -r vault; do
    [ ! -d "$vault/.obsidian" ] || link obsidian/sunset_ember.css "$vault/.obsidian/snippets/sunset_ember.css"
  done
fi

# browser <firefox|zen> <its folder of profiles> <a line for user.js>...: in every profile, the
# link to userChrome.css and the preferences. userContent.css is copied in, not linked (see
# bin/apply-apps), so a file already there that is not that copy is moved aside.
browser() {
  local name="$1" profiles="$2" profile content pref
  shift 2
  for profile in "$profiles"/*/; do
    [ -d "$profile" ] || continue
    link "$name/userChrome.css" "${profile}chrome/userChrome.css"
    content="${profile}chrome/userContent.css"
    if [ -e "$content" ] && [ ! -L "$content" ] && ! cmp -s "$BUILD/$name/userContent.css" "$content"; then
      echo "    moving aside $content -> $content.bak-$STAMP"
      mv "$content" "$content.bak-$STAMP"
    fi
    for pref in "$@"; do
      grep -qF "$pref" "${profile}user.js" 2>/dev/null || echo "$pref" >> "${profile}user.js"
    done
  done
}
# Firefox reads userChrome.css only from a profile that has this preference on.
STYLESHEETS='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
browser firefox "$HOME/Library/Application Support/Firefox/Profiles" "$STYLESHEETS"
# Zen turns its glass to flat grey in a window that is not focused, and gives every page a solid
# backdrop: both off, so the glass stays, and shows through a page with no background of its own.
browser zen "$HOME/Library/Application Support/zen/Profiles" "$STYLESHEETS" \
  'user_pref("zen.view.grey-out-inactive-windows", false);' \
  'user_pref("browser.tabs.allow_transparent_browser", true);'

echo "==> Setting the macOS accent and the desktop picture"
"$REPO/bin/apply-apps"

# spicetify writes the theme into Spotify.app itself; a Spotify update undoes it until the next apply.
if command -v spicetify >/dev/null; then
  echo "==> Writing the theme into Spotify"
  spicetify config current_theme SunsetEmber color_scheme ember inject_css 0 replace_colors 1 >/dev/null || true
  spicetify apply || spicetify backup apply || \
    echo "    (open Spotify once and sign in, then run: spicetify backup apply)"
fi

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
echo "Switch each app theme on once:"
echo "  Obsidian  Settings > Appearance > CSS snippets > sunset_ember, and Translucent window"
echo "  Vesktop   Settings > Vencord > Themes > Sunset Ember"
echo "  Firefox, Zen   restart them"
echo "  Raycast   build/raycast/import  (needs Raycast Pro)"
echo "After a change to theme.ini or config/:  bin/apply"
