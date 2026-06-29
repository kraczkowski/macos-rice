# macOS Rice — Sunset Ember

A tiling-WM macOS setup ("rice"), themed in **Sunset Ember** — dark teal base,
oxidized-iron and ember reds. Configs live in `config/` and are **symlinked**
into `~/.config`, so the whole setup is version-controlled and portable.

No SIP disable required.

## Stack

| Tool | Role |
|------|------|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager |
| [SketchyBar](https://github.com/FelixKratz/SketchyBar) | Custom menu bar |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Active-window glow |
| [Ghostty](https://ghostty.org) | Terminal |
| [Starship](https://starship.rs) | Shell prompt |
| btop · fastfetch · cava | Resource monitor · system info · audio visualizer |
| [Raycast](https://raycast.com) | Launcher |

## Theme — Sunset Ember

One shared palette keeps every tool consistent:

```
bg       #0a1618   surface  #162930   text     #e8d5c2
ember    #b33219   oxidized #a5311a   wine     #5c1416   mahogany #481510
```

`config/sketchybar/colors.sh` is the single source of truth for the bar; the
same values mirror into Ghostty, Starship, btop, cava, and fastfetch.

## Install

Requires macOS + [Homebrew](https://brew.sh). The installer is idempotent and
backs up anything it would overwrite.

```sh
git clone https://github.com/kraczkowski/macos-rice ~/dev/macos-rice
cd ~/dev/macos-rice
./install.sh
```

`install.sh` installs the `Brewfile`, symlinks the configs, adds a managed block
to `~/.zshrc` (Starship + zsh plugins), and starts the bar.

Manual steps it can't do for you:

- Open **AeroSpace.app** once and grant Accessibility permission
  (System Settings → Privacy & Security → Accessibility).
- The `background-music` cask needs your password — run
  `brew install --cask background-music` in your own terminal if the bundle skips it.

## Keybindings

AeroSpace uses `alt` as the modifier.

| Keys | Action |
|------|--------|
| `alt-h/j/k/l` | Focus window left/down/up/right |
| `alt-shift-h/j/k/l` | Move window |
| `alt-minus` / `alt-equal` | Resize smaller / larger |
| `alt-slash` | Toggle split orientation |
| `alt-1…5`, `alt-9` | Switch workspace |
| `alt-shift-1…5`, `alt-shift-9` | Send window to workspace |
| `alt-tab` | Previous workspace |
| `alt-f` | Fullscreen |
| `alt-shift-space` | Toggle float / tile |
| `alt-shift-s` | Launch the showpiece (workspace 9) |
| `alt-shift-;` | Service mode (reload config, reset layout, …) |
| `ctrl-\`` | Ghostty drop-down quick terminal (global) |

Workspaces: `1` code · `2` web · `3` notes · `4` chat · `5` media · `9` showpiece.
Common apps auto-assign to their workspace on launch (see `aerospace.toml`).

## Showpiece

`alt-shift-s` opens the classic unixporn layout as three real, tiled windows on
workspace 9:

```
┌──────────┬──────────┐
│ fastfetch│          │
├──────────┤   btop   │
│   cava   │          │
└──────────┴──────────┘
```

cava reads audio via the **Background Music** loopback. Launching the showpiece
starts Background Music and routes output through it; leaving workspace 9 kills
cava, quits Background Music, and restores your output device. So the orange mic
indicator only shows while the showpiece is actually on screen.

> **Heads-up: the cava setup is a giant pile of macOS workarounds.** macOS has no
> native audio loopback, so you need a virtual device (Background Music). The
> privacy "mic in use" dot can't be hidden without disabling SIP; a Multi-Output
> Device would kill the volume keys; Background Music *and* cava each hold the
> mic open on their own; and the showpiece windows need to be torn down
> programmatically (killing the TUIs, suppressing Ghostty's close prompt,
> re-asserting focus) just to leave the workspace cleanly. On Linux this is one
> line pointing cava at a PipeWire `.monitor` source. Honestly? On macOS you may
> just want to skip cava and enjoy the rest of the rice. 🙃

## Layout

```
Brewfile          install manifest (brew bundle)
install.sh        symlink + setup (idempotent)
bin/showpiece     the three-window showcase
config/<tool>/    each tool's config, symlinked to ~/.config/<tool>/
```

`~/.zshrc` is not tracked (it holds personal aliases); `install.sh` appends a
marker-delimited block to it instead.
