# Zsh Configuration

This directory contains the Zsh environment and interactive shell configuration. It is loaded through `ZDOTDIR`, which points Zsh to this directory.

## How it works

The system-wide `/etc/zshenv` sets `ZDOTDIR` to this directory. The interactive startup flow is:

1. `.zshenv` — loaded by every Zsh process.
2. `.zshrc` — loaded by interactive Zsh shells.
   - `plugins.zsh` loads Antidote and the generated plugin bundle.
   - `compinit` initializes completion after plugins have loaded.
   - `aliases.zsh`, `modules/*.zsh`, and `local/*.zsh` are loaded afterward, in that order.

## Files

- `.zshenv` sets XDG directories, the default editor, the man-page pager, GPG terminal handling, `PATH`, and Python virtualenv prompt behavior.
- `.zshrc` configures history, shell behavior, completion, plugins, aliases, modules, and local overrides.
- `plugins.zsh` loads Antidote and the generated plugin bundle, and provides a plugin update helper.
- `.zsh_plugins.txt` lists the shared plugins managed by Antidote.
- `.zsh_plugins.local.txt` lists machine-specific plugins installed locally.
- `aliases.zsh` provides aliases and helper functions for `eza`, `bat`, `lf`, Git, and navigation.
- `modules/homebrew.zsh` initializes Homebrew when the `brew` command or a standard macOS Homebrew installation is available.
- `modules/podman.zsh` maps `docker` and `docker-compose` to Podman when both Podman commands are installed.
- `modules/starship.zsh` configures and initializes the Starship prompt.
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
- Starship prompt initialization with the tracked configuration in `$XDG_CONFIG_HOME/starship/starship.toml`.
- Optional Docker-compatible Podman aliases when both `podman` and `podman-compose` are available.

## Customization

Add personal or machine-specific settings as `.zsh` files in `local/`. They are loaded last, in filename order, so they can override the shared configuration without changing tracked files. The directory is intentionally ignored by Git because its contents are private and machine-specific.

## Reloading

Use `dotfiles reload` to reload both `.zshenv` and `.zshrc` in the current shell after changing the configuration. The command confirms when the reload completes. After a successful `dotfiles update`, the helper reminds you to run `dotfiles reload` so the updated configuration takes effect.

## Plugins

Install Antidote at `$XDG_DATA_HOME/zsh/antidote` using one of the install methods in the root README: a manual Git clone, or Homebrew on macOS followed by a symlink to this path.

The shared plugin manifest is tracked in [`.zsh_plugins.txt`](.zsh_plugins.txt), while machine-specific additions go in the tracked but locally managed [`.zsh_plugins.local.txt`](.zsh_plugins.local.txt). Running `dotfiles update` automatically marks the local manifest as `skip-worktree`, so ordinary local edits do not appear in Git changes.

Antidote generates the static bundle in `$XDG_CACHE_HOME/zsh/.zsh_plugins.zsh`, so normal shell startup does not perform Git operations.

The main plugin-management aliases are:

| Alias | Command | Purpose |
|---|---|---|
| `zpi` / `zpa` | `zsh-plugin-install` | Install a plugin into the local manifest |
| `zpu` | `zsh-plugins-update` | Update plugins and regenerate the bundle |
| `zpd` / `zpr` | `zsh-plugin-uninstall` | Remove a locally installed plugin |

`zsh-plugin-install` adds `kind:defer` automatically, so plugins are sourced after `compinit` and can register completions with `compdef` — required by most oh-my-zsh plugins. To control loading explicitly, pass a kind yourself (`zpi <repo> -k defer`) or include an annotation in the bundle string (`zpi '<repo> kind:defer'`).

When editing a manifest by hand, append `kind:defer` to each plugin line unless the plugin must load eagerly (for example, completion generators or fpath-only plugins).

For example, to install the oh-my-zsh kubectl plugin:

```zsh
zpi 'ohmyzsh/ohmyzsh path:plugins/kubectl'
```

This appends `ohmyzsh/ohmyzsh path:plugins/kubectl kind:defer` to `.zsh_plugins.local.txt`. Then run `dotfiles reload` (or start a new shell) to load it. The direct Antidote equivalent is:

```zsh
antidote install 'ohmyzsh/ohmyzsh path:plugins/kubectl' "$ZDOTDIR/.zsh_plugins.local.txt"
```

Remove a locally installed plugin with:

```zsh
zpd ohmyzsh/ohmyzsh
```

This deletes the plugin's lines from `.zsh_plugins.local.txt` and removes the cloned plugin directory, then regenerating the bundle with `zpu` finishes the cleanup.

Additional long-form commands and typo-tolerant variants are available in [`plugins.zsh`](plugins.zsh).
