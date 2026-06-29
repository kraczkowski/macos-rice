# macOS rice — install manifest
# Run with:  brew bundle --file=Brewfile

# --- Core ricing stack ---
tap "nikitabobko/tap"
tap "FelixKratz/formulae"

cask "nikitabobko/tap/aerospace"   # tiling window manager (no SIP disable)
brew "sketchybar"                  # scriptable custom menu bar
brew "borders"                     # active-window glow (JankyBorders)

# --- CLI eye-candy ---
brew "fastfetch"                   # system info (debloated config)
brew "btop"                        # resource monitor (themed)

# --- Audio visualizer ---
brew "cava"                        # console audio visualizer
cask "background-music"            # default output w/ loopback for cava; keeps volume keys working
brew "switchaudio-osx"             # CLI output switching; showpiece flips to BGM only while on screen

# --- Terminal + prompt ---
cask "ghostty"                     # fast GPU terminal
brew "starship"                    # cross-shell prompt
brew "zsh-autosuggestions"         # ghost-text suggestions from history
brew "zsh-fast-syntax-highlighting"# colors commands as you type
brew "fzf"                         # fuzzy finder (Ctrl+R history, Ctrl+T files)

# --- Fonts (needed for icons in bar/terminal) ---
cask "font-jetbrains-mono-nerd-font"
cask "sf-symbols"                  # Apple symbols used by sketchybar

# --- Launcher (already installed as app, listed for portability) ---
cask "raycast"
