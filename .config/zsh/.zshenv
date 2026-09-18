# Zsh environment loaded for every shell.

# Keep user files in standard XDG directories.
# Configuration files.
export XDG_CONFIG_HOME="$HOME/.config"
# Temporary caches.
export XDG_CACHE_HOME="$HOME/.cache"
# Persistent application data.
export XDG_DATA_HOME="$HOME/.local/share"
# Logs and other runtime state.
export XDG_STATE_HOME="$HOME/.local/state"

# Default editor for command-line tools.
export EDITOR="nano"
export VISUAL="nano"

# Use bat for readable man pages when available.
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# Keep GPG prompts attached to this terminal.
export GPG_TTY=$(tty)

# Tell Starship where to find its configuration.
export STARSHIP_CONFIG="$ZDOTDIR/starship/starship.toml"

# Use the repository's Tmux configuration when starting Tmux.
export TMUX_CONFIG="$XDG_CONFIG_HOME/tmux/tmux.conf"

# Make personal commands available from any directory.
export PATH="$HOME/.local/bin:$PATH"

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
