# =========================================================
# History
# =========================================================

HISTFILE="$ZDOTDIR/.history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# =========================================================
# Completion
# =========================================================

# Load completion system
autoload -Uz compinit

# Initialize completion with cached metadata file
compinit -d "$ZDOTDIR/.zcompdump"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # lowercase input matches upper and lower

# =========================================================
# Aliases Configurations
# =========================================================

if [[ -f "$ZDOTDIR/aliases.zsh" ]]; then
  source "$ZDOTDIR/aliases.zsh"
fi

# =========================================================
# Modular Config Files
# =========================================================

# Maximum function nesting level
FUNCNEST=100

# Modules
for module in "$XDG_CONFIG_HOME/zsh/modules/"*.zsh; do
  [ -r "$module" ] && source "$module"
done

# =========================================================
# User Custom Configurations
# =========================================================

if [[ -f "$ZDOTDIR/local.zsh" ]]; then
  source "$ZDOTDIR/local.zsh"
fi
