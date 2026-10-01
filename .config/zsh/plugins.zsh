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

  antidote install "$@" "${ANTIDOTE_LOCAL_MANIFEST}"
}

# Keep the previous helper name as a compatibility alias.
alias zplugin-update='zsh-plugins-update'

alias zpi='zsh-plugin-install'
alias zpu='zsh-plugins-update'
