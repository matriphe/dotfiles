# Zsh Configuration

This directory contains the Zsh environment and interactive shell configuration. It is loaded through `ZDOTDIR`, which points Zsh to this directory.

## How it works

The system-wide `/etc/zshenv` sets `ZDOTDIR` to this directory. Zsh then loads the files in this order:

1. `.zshenv` — loaded by every Zsh process.
2. `.zshrc` — loaded by interactive Zsh shells.
3. `local.zsh` — optional machine-specific settings loaded last.

## Files

- `.zshenv` sets XDG directories, the default editor, the man-page pager, GPG terminal handling, `PATH`, and Python virtualenv prompt behavior.
- `.zshrc` configures history, shell behavior, completion, aliases, modules, and local overrides.
- `aliases.zsh` provides aliases and helper functions for `eza`, `bat`, ripgrep, `lf`, Git, and navigation.
- `modules/` contains optional configuration modules loaded automatically.
- `local.zsh` can contain machine-specific settings and is ignored by Git.
- `.history` stores Zsh command history and is ignored by Git.
- `.zcompdump` stores the Zsh completion cache and is ignored by Git.
- `.gitignore` excludes generated and machine-local files.

## Included functionality

- XDG-based configuration, cache, data, and state paths.
- Persistent history with duplicate and whitespace filtering.
- Interactive and case-insensitive command completion.
- `eza`, `bat`, and ripgrep aliases for common command-line tools.
- `lf` directory navigation that returns to the selected directory.
- Git log shortcuts and a `dotfiles` helper for updating, committing, and pushing the bare repository.
- Starship prompt initialization.
- Conditional Docker-compatible aliases backed by Podman.

## Customization

Add personal or machine-specific settings to `local.zsh`. It is loaded last so it can override the shared configuration without changing tracked files.
