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
# Modular Config Files
# =========================================================

# Modules before plugins: homebrew.zsh adds Homebrew's completion
# directory to fpath, which must exist before the autocomplete plugin
# runs its own compinit.
for module in "$XDG_CONFIG_HOME/zsh/modules/"*.zsh(N); do
  [ -r "$module" ] && source "$module"
done

# =========================================================
# Plugins
# =========================================================

source "$ZDOTDIR/plugins.zsh"

# Tab opens the completion menu instead of inserting the first listed
# completion (zsh-autocomplete's default); Shift-Tab expands the word.
bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

# =========================================================
# Aliases Configurations
# =========================================================

if [[ -f "$ZDOTDIR/aliases.zsh" ]]; then
  source "$ZDOTDIR/aliases.zsh"
fi

# =========================================================
# Function nesting limit
# =========================================================

# Maximum function nesting level
FUNCNEST=100

# =========================================================
# User Custom Configurations
# =========================================================

for local_config in "$ZDOTDIR/local/"*.zsh(N); do
  [[ -r "$local_config" ]] && source "$local_config"
done
