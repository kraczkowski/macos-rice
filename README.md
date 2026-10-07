# macOS Rice — Sunset Ember

A tiling-WM macOS setup ("rice"), themed in **Sunset Ember** — dark teal base,
oxidized-iron and ember reds. One file, `theme.ini`, holds every colour; the
configs in `config/` name them, and what `~/.config` links to is rendered from both.

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
| Vim · matplotlib | Editor and plot windows in the same look |
| [Raycast](https://raycast.com) | Launcher |

## Theme — Sunset Ember

`theme.ini` is the one place a colour, the font or the glass effect is typed:

```ini
base  = 0a1618  # dark teal: every background
ember = b33219  # the accent: focus, cursor, prompt, alerts
```

A file under `config/` names a value instead of typing it: `#{{ember}}` in
Ghostty, `0xff{{ember}}` in the bar, `{{ember|rgb}}` in fastfetch. `bin/render`
writes the theme into those templates and saves the result in `build/`, which is
what `~/.config` links to. It stops, naming the file, if a template names
something the theme lacks or types a colour out.

After a change to `theme.ini` or anything under `config/`:

```sh
bin/apply    # render, then reload the bar, the window manager and the borders
```

A new theme is a new `theme.ini`.

## Install

Requires macOS + [Homebrew](https://brew.sh). The installer is idempotent and
backs up anything it would overwrite.

```sh
git clone https://github.com/kraczkowski/macos-rice ~/dev/macos-rice
cd ~/dev/macos-rice
./install.sh
```

`install.sh` installs the `Brewfile`, renders and links the configs, adds one
`source` line to `~/.zshrc`, hides the native menu bar and starts the bar.

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
starts Background Music and routes output through it; leaving workspace 9 closes
those three windows (and only those), quits Background Music, and restores your output device. So the orange mic
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
theme.ini         every colour, the font, the glass effect
config/<tool>/    each tool's config, naming the theme's values
build/<tool>/     the rendered configs ~/.config links to (not in git)
bin/render        theme.ini + config/ -> build/
bin/apply         render, then reload what is running
bin/showpiece     the three-window showcase: up | down | leave <workspace>
bin/on-workspace-change   run by AeroSpace: the bar's dot, and taking the showpiece down
Brewfile          install manifest (brew bundle)
install.sh        packages, render, links (safe to re-run)
```

`~/.zshrc` is not tracked (it holds personal aliases); it sources
`build/zsh/rice.zsh`, where everything the rice adds to the shell lives.
