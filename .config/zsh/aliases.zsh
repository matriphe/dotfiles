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
# (some Linux packages omit them; Homebrew and official .deb/.rpm do not).
# zsh-autocomplete defers compinit to ZLE startup, so _comps is still
# empty here; re-check in a deferred task that runs after compinit.
zsh-defer '(( $+_comps[eza] )) || compdef eza=ls'

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

_dotfiles_sync_from_upstream() (
    emulate -L zsh

    local operation="$1"
    local git_dir="$HOME/.dotfiles"
    local work_tree="$HOME"
    local zsh_dir="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
    local manifest_path="$zsh_dir/.zsh_plugins.local.txt"
    local manifest_relative="${manifest_path#"$work_tree"/}"
    local manifest_backup=""
    local manifest_tracked=0
    local upstream_ref remote_name remote_branch target
    local -a gitcmd=(git -C "$work_tree" --git-dir="$git_dir" --work-tree="$work_tree")

    if ! "${gitcmd[@]}" rev-parse --git-dir >/dev/null 2>&1; then
        print -u2 "dotfiles $operation: repository not found at $git_dir"
        return 1
    fi

    upstream_ref=$("${gitcmd[@]}" rev-parse --symbolic-full-name '@{upstream}' 2>/dev/null) || {
        print -u2 "dotfiles $operation: current branch has no configured upstream"
        return 1
    }
    if [[ "$upstream_ref" != refs/remotes/*/* ]]; then
        print -u2 "dotfiles $operation: upstream is not a remote tracking branch: $upstream_ref"
        return 1
    fi
    remote_branch="${upstream_ref#refs/remotes/}"
    remote_name="${remote_branch%%/*}"

    if ! "${gitcmd[@]}" fetch --prune "$remote_name"; then
        print -u2 "dotfiles $operation: failed to fetch from $remote_name"
        return 1
    fi
    target=$("${gitcmd[@]}" rev-parse --verify "${upstream_ref}^{commit}" 2>/dev/null) || {
        print -u2 "dotfiles $operation: fetched upstream commit could not be resolved: $upstream_ref"
        return 1
    }

    if [[ "$manifest_path" == "$work_tree"/* ]] && \
        "${gitcmd[@]}" ls-files --error-unmatch -- "$manifest_relative" >/dev/null 2>&1; then
        manifest_tracked=1
        if [[ -e "$manifest_path" ]]; then
            manifest_backup=$(command mktemp "${TMPDIR:-/tmp}/dotfiles-local-manifest.XXXXXX") || {
                print -u2 "dotfiles $operation: could not save the local Zsh plugin manifest"
                return 1
            }
            if ! command cp -p "$manifest_path" "$manifest_backup"; then
                command rm -f "$manifest_backup"
                print -u2 "dotfiles $operation: could not save the local Zsh plugin manifest"
                return 1
            fi
        fi
        if ! "${gitcmd[@]}" update-index --no-skip-worktree -- "$manifest_relative"; then
            [[ -z "$manifest_backup" ]] || command rm -f "$manifest_backup"
            print -u2 "dotfiles $operation: could not prepare the local Zsh plugin manifest for reset"
            return 1
        fi
    fi

    if ! "${gitcmd[@]}" reset --hard "$target"; then
        if [[ -n "$manifest_backup" ]] && ! command cp -p "$manifest_backup" "$manifest_path"; then
            print -u2 "dotfiles $operation: reset failed; recover the local manifest from $manifest_backup"
            return 1
        fi
        if (( manifest_tracked )) && [[ -e "$manifest_path" ]] && \
            ! "${gitcmd[@]}" update-index --skip-worktree -- "$manifest_relative"; then
            print -u2 "dotfiles $operation: reset failed and could not restore skip-worktree on the local manifest"
            return 1
        fi
        [[ -z "$manifest_backup" ]] || command rm -f "$manifest_backup"
        print -u2 "dotfiles $operation: failed to reset tracked files to $upstream_ref"
        return 1
    fi

    if [[ -n "$manifest_backup" ]] && ! command cp -p "$manifest_backup" "$manifest_path"; then
        if (( manifest_tracked )) && [[ -e "$manifest_path" ]]; then
            "${gitcmd[@]}" update-index --skip-worktree -- "$manifest_relative" >/dev/null 2>&1
        fi
        print -u2 "dotfiles $operation: reset succeeded, but the local manifest backup remains at $manifest_backup"
        return 1
    fi
    if (( manifest_tracked )) && [[ -e "$manifest_path" ]] && \
        "${gitcmd[@]}" ls-files --error-unmatch -- "$manifest_relative" >/dev/null 2>&1 && \
        ! "${gitcmd[@]}" update-index --skip-worktree -- "$manifest_relative"; then
        [[ -z "$manifest_backup" ]] || print -u2 "dotfiles $operation: local manifest backup: $manifest_backup"
        print -u2 "dotfiles $operation: reset succeeded, but could not mark the local manifest skip-worktree"
        return 1
    fi
    if [[ -n "$manifest_backup" ]] && ! command rm -f "$manifest_backup"; then
        print -u2 "dotfiles $operation: reset succeeded, but could not remove temporary manifest backup $manifest_backup"
        return 1
    fi

    if ! "${gitcmd[@]}" submodule sync --recursive; then
        print -u2 "dotfiles $operation: dotfiles were reset, but submodule URL synchronization failed"
        return 1
    fi
    if ! "${gitcmd[@]}" submodule update --init --recursive --force; then
        print -u2 "dotfiles $operation: dotfiles were reset, but recursive submodule update failed"
        return 1
    fi

    print "Dotfiles synchronized to $target from $upstream_ref."
    print "Remember to run 'dotfiles reload' to reload the updated configuration."
)

dotfiles() {
    local zsh_dir="${ZDOTDIR:-$HOME/.config/zsh}"
    local tmux_conf="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
    local answer
    local -a gitcmd=(git -C "$HOME" --git-dir="$HOME/.dotfiles" --work-tree="$HOME")

    case "$1" in
        reload)
            if ! source "$zsh_dir/.zshenv"; then
                print -u2 "dotfiles reload: failed to source $zsh_dir/.zshenv"
                return 1
            fi
            if ! source "$zsh_dir/.zshrc"; then
                print -u2 "dotfiles reload: failed to source $zsh_dir/.zshrc"
                return 1
            fi
            print "Zsh configuration reloaded."

            if ! command -v tmux >/dev/null 2>&1; then
                print "Tmux is not installed; skipped tmux reload."
                return 0
            fi
            if ! tmux display-message -p '#S' >/dev/null 2>&1; then
                print "No tmux server is running; configuration will load on the next start."
                return 0
            fi
            if ! tmux source-file "$tmux_conf"; then
                print -u2 "dotfiles reload: failed to source tmux configuration $tmux_conf"
                return 1
            fi
            print "Tmux configuration reloaded."
            return 0
            ;;
        update)
            shift
            if (( $# )); then
                print -u2 "Usage: dotfiles update"
                return 2
            fi
            _dotfiles_sync_from_upstream update
            return $?
            ;;
        update-force)
            shift
            local skip_confirmation=0
            if [[ "${1:-}" == -y ]]; then
                skip_confirmation=1
                shift
            fi
            if (( $# )); then
                print -u2 "Usage: dotfiles update-force [-y]"
                return 2
            fi
            if (( ! skip_confirmation )); then
                print "This overwrites tracked files and local commits with the remote state."
                print "The local Zsh plugin manifest and untracked files are preserved."
                printf 'Continue? [y/N] '
                if ! read -r answer; then
                    print -u2 "dotfiles update-force: could not read confirmation"
                    return 1
                fi
                if [[ "$answer" != y ]]; then
                    print "dotfiles update-force: cancelled"
                    return 1
                fi
            fi
            _dotfiles_sync_from_upstream update-force
            return $?
            ;;
    esac

    "${gitcmd[@]}" "$@"
    return $?
}
