# Everything the rice adds to zsh. ~/.zshrc sources the rendered copy of this file:
# one line, added by install.sh. Personal aliases stay in ~/.zshrc, which is not in the repo.

eval "$(starship init zsh)"

# --- plugins: suggestions from history, fuzzy finder, colours as you type ---
# fast-syntax-highlighting must load last.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#{{muted}}'
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
command -v fzf >/dev/null && source <(fzf --zsh)
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# --- window titles: the running program's name, or "zsh" at the prompt (no folder, no ghost) ---
autoload -Uz add-zsh-hook
_rice_title_precmd() { print -Pn '\e]0;zsh\a' }
_rice_title_preexec() { print -Pn '\e]0;'"${1%% *}"'\a' }
add-zsh-hook precmd _rice_title_precmd
add-zsh-hook preexec _rice_title_preexec

# --- matplotlib: plot windows use the Ghostty-style backend beside this file ---
export PYTHONPATH="{{repo}}/build/matplotlib${PYTHONPATH:+:$PYTHONPATH}"
export MPLBACKEND="module://ember_backend"
