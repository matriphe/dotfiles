# Antidote plugin loading.

typeset -g ANTIDOTE_MANIFEST="${ZDOTDIR}/.zsh_plugins.txt"

if [[ ! -r "${ANTIDOTE_HOME}/antidote.zsh" ]]; then
  print -u2 "Antidote is not installed at ${ANTIDOTE_HOME}"
else
  source "${ANTIDOTE_HOME}/antidote.zsh"

  mkdir -p "${ANTIDOTE_BUNDLE:h}"

  # Regenerate when the manifest is newer, or when the antidote install
  # changed (the cached bundle can hold stale absolute paths after a
  # version bump or a move between machines).
  if [[ ! -r "${ANTIDOTE_BUNDLE}" ||
        "${ANTIDOTE_MANIFEST}" -nt "${ANTIDOTE_BUNDLE}" ||
        "${ANTIDOTE_HOME}/antidote.zsh" -nt "${ANTIDOTE_BUNDLE}" ]]; then
    antidote bundle <"${ANTIDOTE_MANIFEST}" >"${ANTIDOTE_BUNDLE}"
  fi

  source "${ANTIDOTE_BUNDLE}"
fi

zsh-plugins-update() {
  if (( ! $+functions[antidote] )); then
    print -u2 "Antidote is not installed at ${ANTIDOTE_HOME}"
    return 1
  fi

  antidote update
  antidote bundle <"${ANTIDOTE_MANIFEST}" >"${ANTIDOTE_BUNDLE}"
}

# Keep the previous helper name as a compatibility alias.
alias zplugin-update='zsh-plugins-update'
