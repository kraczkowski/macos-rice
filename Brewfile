# macOS rice — install manifest
# Run with:  brew bundle --file=Brewfile

# --- Core ricing stack ---
tap "nikitabobko/tap"
tap "FelixKratz/formulae"

cask "nikitabobko/tap/aerospace"   # tiling window manager (no SIP disable)
brew "sketchybar"                  # scriptable custom menu bar
brew "borders"                     # active-window glow (JankyBorders)

# --- Audio visualizer ---
brew "cava"                        # console audio visualizer
cask "blackhole-2ch"               # virtual loopback device (route system audio to cava)

# --- Terminal + prompt ---
cask "ghostty"                     # fast GPU terminal
brew "starship"                    # cross-shell prompt

# --- Fonts (needed for icons in bar/terminal) ---
cask "font-jetbrains-mono-nerd-font"
cask "sf-symbols"                  # Apple symbols used by sketchybar

# --- Launcher (already installed as app, listed for portability) ---
cask "raycast"
