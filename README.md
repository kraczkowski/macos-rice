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
| btop · fastfetch | Resource monitor · system info |
| Vim · matplotlib | Editor and plot windows in the same look |
| Obsidian · Firefox · Zen · Vesktop (Discord) · Spotify | The same colours, each through its own theme file |
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

The one step it can't do for you: open **AeroSpace.app** once and grant Accessibility
permission (System Settings → Privacy & Security → Accessibility).

## Apps

The GUI apps take the theme from the same `theme.ini`, each in the one way it allows:

| App | What carries the theme | Switch it on once |
|-----|------------------------|-------------------|
| Finder, System Settings, native apps | accent and selection colour (`config/macos/accent`) | restart the app |
| Obsidian | a CSS snippet, linked into every vault | Settings → Appearance → CSS snippets, and Translucent window for the glass |
| Firefox | `userChrome.css`, linked into every profile | restart Firefox |
| Zen | `userChrome.css` over its own see-through window, linked into every profile | restart Zen |
| Discord | a Vencord theme, loaded by Vesktop | Settings → Vencord → Themes; for the glass, `"macosVibrancyStyle": "fullscreen-ui"` in Vesktop's `settings/settings.json` |
| Raycast | a theme link (`config/raycast/import`), needs Raycast Pro | run `build/raycast/import`, confirm in Raycast |
| qBittorrent | colours laid over its built-in theme (`config/qbittorrent/`) | restart qBittorrent |
| Spotify | a spicetify colour scheme, written into Spotify.app | — (after a Spotify update: `spicetify apply`) |

Vesktop and spicetify are unofficial: Discord's terms do not allow modified clients, and
spicetify patches Spotify.app. The stock Discord app stays installed and untouched.

## Next

Make the workflow feel more like a tiling desktop, in the manner of [niri](https://github.com/YaLTeR/niri):
windows in a strip that scrolls sideways instead of shrinking to fit the screen. AeroSpace has no
such layout; [PaperWM.spoon](https://github.com/mogenson/PaperWM.spoon) is the macOS take on it and
the first thing to try.

## Keybindings

AeroSpace uses `alt` as the modifier.

| Keys | Action |
|------|--------|
| `alt-h/j/k/l` | Focus window left/down/up/right |
| `alt-shift-h/j/k/l` | Move window |
| `alt-minus` / `alt-equal` | Resize smaller / larger |
| `alt-slash` | Toggle split orientation |
| `alt-1…6`, `alt-9` | Switch workspace |
| `alt-shift-1…6`, `alt-shift-9` | Send window to workspace |
| `alt-tab` | Previous workspace |
| `alt-f` | Fullscreen |
| `alt-shift-space` | Toggle float / tile |
| `alt-shift-s` | The showpiece (workspace 9): open it, go to it, or from there close it |
| `alt-b` | Open the custom browser |
| `alt-shift-;` | Service mode (reload config, reset layout, …) |
| `ctrl-\`` | Ghostty drop-down quick terminal (global) |

Workspaces: `1` code · `2` web · `3` notes · `4` chat · `5` media · `6` system (Finder, System Settings) · `9` showpiece.
Common apps auto-assign to their workspace on launch (see `aerospace.toml`).

## Showpiece

`alt-shift-s` opens the classic unixporn layout as three real, tiled windows on
workspace 9:

```
┌──────────┬──────────┐
│ fastfetch│          │
├──────────┤   btop   │
│   fire   │          │
└──────────┴──────────┘
```

The same key goes to the showpiece when it is open and you are elsewhere, and pressed on
workspace 9 closes those three windows (and only those) and goes back to where you were.

The fire is `config/showpiece/fire`, a page of Python in the colours of the theme. It burns as
high as the machine is busy: low on an idle one, to the top when every core is at work.

## Layout

```
theme.ini         every colour, the font, the glass effect
config/<tool>/    each tool's config, naming the theme's values
build/<tool>/     the rendered configs ~/.config links to (not in git)
bin/render        theme.ini + config/ -> build/
bin/apply         render, then reload what is running
bin/apply-apps    the macOS accent and the desktop picture, which keep a copy of their own
bin/showpiece     the three-window showcase, opened and closed by alt-shift-s
bin/wallpaper     the desktop picture, drawn from a formula, and a window to design it in
Brewfile          install manifest (brew bundle)
install.sh        packages, render, links (safe to re-run)
```

`~/.zshrc` is not tracked (it holds personal aliases); it sources
`build/zsh/rice.zsh`, where everything the rice adds to the shell lives.
