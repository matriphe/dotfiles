# Better ls
unalias ls 2>/dev/null
ls() {
    if [[ "$#" -eq 1 && "$1" == Backup && ! -e "$1" && -e "$HOME/Backup" ]]; then
        command env -u LS_COLORS -u EZA_COLORS eza --color=always --icons=auto "$HOME/Backup"
    else
        command env -u LS_COLORS -u EZA_COLORS eza --color=always --icons=auto "$@"
    fi
}

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Fall back to ls completions only when eza ships none of its own
# (some Linux packages omit them; Homebrew and official .deb/.rpm do not)
(( $+_comps[eza] )) || compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

# Colorize grep but keep real grep semantics (rg's -E is --encoding, not extended regex)
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory

lf() { # zsh follow lf navigation
    local tmp dir

    tmp=$(mktemp) || return 1
    command lf -last-dir-path="$tmp" "$@"
    if [[ -f "$tmp" ]]; then
        dir=$(<"$tmp")
        rm -f "$tmp"
        [[ -d "$dir" && "$dir" != "$PWD" ]] && cd -- "$dir"
    fi
}

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

dotfiles() {
    local g="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
    local local_plugin_manifest="$ZDOTDIR/.zsh_plugins.local.txt"
    if [[ "$1" == reload ]]; then
        source "$ZDOTDIR/.zshenv"
        source "$ZDOTDIR/.zshrc"
        print "Zsh configuration reloaded."
        return
    elif [[ "$1" == update-force ]]; then
        shift
        local -a yes=(n)
        [[ "${#argv}" -gt 0 && "${argv[1]}" == -y ]] && { yes=(y); shift; }
        print "This resets every tracked file in $HOME to the repository state."
        print "Local changes to tracked files will be LOST."
        if [[ "${yes}" != y ]]; then
            printf 'Continue? [y/N] '
            read -r answer
            [[ "$answer" == y ]] || return 1
        fi
        ${=g} fetch origin
        # Checkout with a tree-ish updates both work-tree and index; HEAD is
        # fast-forwarded afterwards. Skip-worktree files are left untouched.
        ${=g} checkout FETCH_HEAD -- . 2>&1 | grep -v "sparse-checkout" 1>&2
        ${=g} merge --ff-only FETCH_HEAD && \
            ${=g} update-index --skip-worktree -- "$local_plugin_manifest"
        print "Tracked files reset to the repository state."
        print "Remember to run 'dotfiles reload' to reload the updated configuration."
        return
    elif [[ "$1" == update ]]; then
        shift
        ${=g} fetch origin
        local -a to_reset=() conflicts=()
        local f
        # A dirty work-tree file whose content already matches the incoming
        # version would needlessly block the pull; reset only those, keep real edits.
        for f in $(${=g} diff --name-only HEAD FETCH_HEAD -- 2>/dev/null); do
            if ${=g} diff --quiet HEAD -- "$f" && [[ -e "$f" ]]; then
                continue
            elif [[ "$(${=g} hash-object "$f" 2>/dev/null)" == "$(${=g} rev-parse "FETCH_HEAD:$f" 2>/dev/null)" ]]; then
                to_reset+=("$f")
            else
                conflicts+=("$f")
            fi
        done
        if (( ${#conflicts} )); then
            print -u2 "dotfiles update: local changes would be overwritten by merge:"
            printf '  %s\n' "${conflicts[@]}" 1>&2
            print -u2 "Commit, stash, or remove these changes, then retry."
            return 1
        fi
        if (( ${#to_reset} )); then
            ${=g} checkout -- "${to_reset[@]}"
        fi
        # FETCH_HEAD is already fetched above; merging directly avoids a
        # second fetch inside pull.
        ${=g} merge --ff-only FETCH_HEAD && \
            ${=g} update-index --skip-worktree -- "$local_plugin_manifest" && \
            print "Remember to run 'dotfiles reload' to reload the updated configuration."
        return
    fi

    ${=g} "$@"
}
