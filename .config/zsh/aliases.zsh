# Better ls
unalias ls 2>/dev/null
ls() {
    if [[ "$#" -eq 1 && "$1" == Backup && ! -e "$1" && -e "$HOME/Backup" ]]; then
        command eza --icons=auto "$HOME/Backup"
    else
        command eza --icons=auto "$@"
    fi
}

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory

lf() { # zsh follow lf navigation
    tmp=$(mktemp)
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir=$(cat "$tmp")
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# =========================================================(if the)
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

dotfiles() {
    if [[ "$1" == reload ]]; then
        source "$ZDOTDIR/.zshenv"
        source "$ZDOTDIR/.zshrc"
        print "Zsh configuration reloaded."
        return
    elif [[ "$1" == update ]]; then
        shift
        git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" pull --ff-only "$@"
        if (( $? == 0 )); then
            print "Remember to run 'dotfiles reload' to reload the updated configuration."
        fi
        return
    fi

    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}
