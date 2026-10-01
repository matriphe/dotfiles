# Antidote plugin loading.

typeset -g ANTIDOTE_MANIFEST="${ZDOTDIR}/.zsh_plugins.txt"
typeset -g ANTIDOTE_LOCAL_MANIFEST="${ZDOTDIR}/.zsh_plugins.local.txt"

# Locate the antidote.zsh loader. ANTIDOTE_HOME is the plugin data dir; a
# git-clone install keeps the loader there. On macOS, Homebrew installs the
# loader under its share directory instead.
typeset -g ANTIDOTE_ZSH=""
if [[ -r "${ANTIDOTE_HOME}/antidote.zsh" ]]; then
  ANTIDOTE_ZSH="${ANTIDOTE_HOME}/antidote.zsh"
elif [[ "${OSTYPE}" == darwin* ]]; then
  for _brew_prefix in /opt/homebrew /usr/local; do
    if [[ -r "${_brew_prefix}/opt/antidote/share/antidote/antidote.zsh" ]]; then
      ANTIDOTE_ZSH="${_brew_prefix}/opt/antidote/share/antidote/antidote.zsh"
      break
    fi
  done
fi

if [[ -z "${ANTIDOTE_ZSH}" ]]; then
  print -u2 "Antidote is not installed (checked ${ANTIDOTE_HOME})"
else
  source "${ANTIDOTE_ZSH}"

  # oh-my-zsh plugins expect ZSH_CACHE_DIR (see .zshenv) and write
  # completion caches under completions/.
  mkdir -p "${ZSH_CACHE_DIR}/completions"

  mkdir -p "${ANTIDOTE_BUNDLE:h}"

  # Regenerate when the manifest is newer, or when the antidote install
  # changed (the cached bundle can hold stale absolute paths after a
  # version bump or a move between machines).
  if [[ ! -r "${ANTIDOTE_BUNDLE}" ||
        "${ANTIDOTE_MANIFEST}" -nt "${ANTIDOTE_BUNDLE}" ||
        "${ANTIDOTE_LOCAL_MANIFEST}" -nt "${ANTIDOTE_BUNDLE}" ||
        "${ANTIDOTE_ZSH}" -nt "${ANTIDOTE_BUNDLE}" ]]; then
    if [[ -r "${ANTIDOTE_LOCAL_MANIFEST}" ]]; then
      antidote bundle < <(cat "${ANTIDOTE_MANIFEST}" "${ANTIDOTE_LOCAL_MANIFEST}") >"${ANTIDOTE_BUNDLE}"
    else
      antidote bundle <"${ANTIDOTE_MANIFEST}" >"${ANTIDOTE_BUNDLE}"
    fi
  fi

  source "${ANTIDOTE_BUNDLE}"
fi

zsh-plugins-update() {
  if [[ -z "${ANTIDOTE_ZSH}" ]]; then
    print -u2 "Antidote is not installed (checked ${ANTIDOTE_HOME})"
    return 1
  fi

  antidote update
  if [[ -r "${ANTIDOTE_LOCAL_MANIFEST}" ]]; then
    antidote bundle < <(cat "${ANTIDOTE_MANIFEST}" "${ANTIDOTE_LOCAL_MANIFEST}") >"${ANTIDOTE_BUNDLE}"
  else
    antidote bundle <"${ANTIDOTE_MANIFEST}" >"${ANTIDOTE_BUNDLE}"
  fi
}

zsh-plugin-install() {
  if (( $# == 0 )); then
    print -u2 "usage: zsh-plugin-install <plugin> [plugin options...]"
    return 1
  fi

  # Defer by default so plugins source after compinit and can call
  # compdef, which oh-my-zsh plugins rely on. Skip if the user already
  # set a kind via flag or annotation.
  local has_kind=0
  local arg
  for arg in "$@"; do
    if [[ "$arg" == (-k|--kind) || "$arg" == *kind:* ]]; then
      has_kind=1
      break
    fi
  done
  if (( has_kind )); then
    antidote install "$@" "${ANTIDOTE_LOCAL_MANIFEST}"
  else
    antidote install -k defer "$@" "${ANTIDOTE_LOCAL_MANIFEST}"
  fi
}

zsh-plugin-uninstall() {
  if (( $# == 0 )); then
    print -u2 "usage: zsh-plugin-uninstall <plugin>"
    return 1
  fi

  if [[ ! -r "${ANTIDOTE_LOCAL_MANIFEST}" ]]; then
    print -u2 "No local plugin manifest at ${ANTIDOTE_LOCAL_MANIFEST}"
    return 1
  fi

  local bundle="$1"
  local repo="${bundle%%[[:blank:]]*}"
  repo="${repo#https://}"
  repo="${repo#http://}"
  repo="${repo#git@}"
  repo="${repo%.git}"

  # Remove matching lines from the local manifest.
  local tmp="${ANTIDOTE_LOCAL_MANIFEST}.tmp.$$"
  awk -v b="$repo" '
    {
      l = $0
      sub(/^[[:blank:]]+/, "", l)
      if (l == b || substr(l, 1, length(b) + 1) == b " ") {
        print "Removed: " $0 > "/dev/stderr"
        next
      }
      print
    }' "${ANTIDOTE_LOCAL_MANIFEST}" > "${tmp}" \
    && mv "${tmp}" "${ANTIDOTE_LOCAL_MANIFEST}" \
    || { rm -f "${tmp}"; print -u2 "Failed to update ${ANTIDOTE_LOCAL_MANIFEST}"; return 1; }

  # Drop the cloned plugin directory, if present.
  local plugindir="${ANTIDOTE_HOME}/github.com/${repo}"
  if [[ -d "${plugindir}" ]]; then
    rm -rf "${plugindir}"
    print "Removed ${plugindir}"
  fi

  print "Run 'zpu' and restart the shell (or run 'dotfiles reload') to finish."
}

# Keep the previous helper name as a compatibility alias.
alias zplugin-update='zsh-plugins-update'

# Accept common singular, plural, and misspelled command variants.
alias zsh-plugins-install='zsh-plugin-install'
alias zsh-plugin-update='zsh-plugins-update'
alias zsh-plugins-uninstall='zsh-plugin-uninstall'
alias zsh-plugins-uninstal='zsh-plugin-uninstall'
alias zsh-plugin-uninstal='zsh-plugin-uninstall'
alias zsh-plugins-unistall='zsh-plugin-uninstall'
alias zsh-plugin-unistall='zsh-plugin-uninstall'
alias zsh-plug-in-uninstall='zsh-plugin-uninstall'
alias zsh-plugin-add='zsh-plugin-install'
alias zsh-plugins-add='zsh-plugin-install'
alias zsh-plugin-ad='zsh-plugin-install'
alias zsh-plugins-ad='zsh-plugin-install'
alias zsh-plugin-adds='zsh-plugin-install'
alias zsh-plugin-dd='zsh-plugin-install'
alias zsh-plugin-add-plugin='zsh-plugin-install'
alias zsh-plugins-add-plugins='zsh-plugin-install'
alias zpi='zsh-plugin-install'
alias zpa='zsh-plugin-install'
alias zpu='zsh-plugins-update'
alias zpd='zsh-plugin-uninstall'
alias zpr='zsh-plugin-uninstall'
