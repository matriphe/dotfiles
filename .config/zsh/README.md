# Zsh Configuration

This directory contains the Zsh environment and interactive shell configuration. It is loaded through `ZDOTDIR`, which points Zsh to this directory.

## How it works

The system-wide `/etc/zshenv` sets `ZDOTDIR` to this directory. The interactive startup flow is:

1. `.zshenv` — loaded by every Zsh process.
2. `.zshrc` — loaded by interactive Zsh shells.
   - `plugins.zsh` loads Antidote and the generated plugin bundle.
   - `compinit` initializes completion after plugins have loaded.
   - aliases, modules, and `local/*.zsh` are loaded afterward.

## Files

- `.zshenv` sets XDG directories, the default editor, the man-page pager, GPG terminal handling, `PATH`, and Python virtualenv prompt behavior.
- `.zshrc` configures history, shell behavior, completion, plugins, aliases, modules, and local overrides.
- `plugins.zsh` loads Antidote and the generated plugin bundle, and provides a plugin update helper.
- `.zsh_plugins.txt` lists the plugins managed by Antidote.
- `aliases.zsh` provides aliases and helper functions for `eza`, `bat`, `lf`, Git, and navigation.
- `modules/` contains optional configuration modules loaded automatically.
- `local/` can contain machine-specific settings split across any number of `.zsh` files and is ignored by Git.
- `.history` stores Zsh command history and is ignored by Git.
- `.zcompdump` stores the Zsh completion cache and is ignored by Git.
- `.gitignore` excludes generated and machine-local files.

## Included functionality

- XDG-based configuration, cache, data, and state paths.
- Persistent history with duplicate and whitespace filtering.
- Interactive and case-insensitive command completion.
- `eza` and `bat` aliases for common command-line tools; ripgrep installed as a standalone search tool (`grep` is not aliased to it because their flags differ).
- `lf` directory navigation that returns to the selected directory.
- Git log shortcuts and a `dotfiles` helper for reloading the Zsh environment, updating, committing, and pushing the bare repository.
- Starship prompt initialization.
- No Docker or Podman aliases are included; install a container runtime separately if your workflow needs one.

## Customization

Add personal or machine-specific settings as `.zsh` files in `local/`. They are loaded last, in filename order, so they can override the shared configuration without changing tracked files. The directory is intentionally ignored by Git because its contents are private and machine-specific.

## Reloading

Use `dotfiles reload` to reload both `.zshenv` and `.zshrc` in the current shell after changing the configuration. The command confirms when the reload completes. After a successful `dotfiles update`, the helper reminds you to run `dotfiles reload` so the updated configuration takes effect.

## Plugins

Install Antidote at `$XDG_DATA_HOME/zsh/antidote` using one of the install methods in the root README: a manual Git clone, or Homebrew on macOS followed by a symlink to this path. The plugin manifest is tracked in [`.zsh_plugins.txt`](.zsh_plugins.txt). Antidote generates the static bundle in `$XDG_CACHE_HOME/zsh/.zsh_plugins.zsh`, so normal shell startup does not perform Git operations. Update installed plugins with:

```zsh
zsh-plugins-update
```
