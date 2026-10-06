# Tmux Configuration

This directory contains the Tmux configuration used by this dotfiles repository. Tmux automatically loads `tmux.conf` from `$XDG_CONFIG_HOME/tmux/tmux.conf`.

The configuration uses a 1-based index for windows and panes, keeps the default `Ctrl-b` prefix, and supports `Ctrl-B` as a secondary prefix.

TPM is tracked as a Git submodule at `plugins/tpm`. At runtime, tmux loads it from `$XDG_CONFIG_HOME/tmux/plugins/tpm` (normally `$HOME/.config/tmux/plugins/tpm`); it loads from the home-directory checkout, not the separate `~/Projects/dotfiles` working copy.

TPM-managed plugins are installed alongside it in `plugins/`; those plugin checkouts are ignored by the dotfiles repository.

Add plugin declarations with TPM's `@plugin` option in `tmux.conf`, then press `prefix + I` to install them. `dotfiles update` and `dotfiles update-force` initialize and update the TPM submodule.

The `xamut/tmux-weather` plugin shows the location inferred from your IP address, current conditions, temperature, humidity, and wind speed in the status line. It uses metric units and requires `curl` and `sed`.

To reload both Zsh and the running tmux configuration, use `dotfiles reload`.

## Key bindings

All `prefix` bindings below use `Ctrl-b` or `Ctrl-B` first.

### Mouse

- `prefix + m` — enable mouse mode.
- `prefix + n` — disable mouse mode.

Mouse mode is disabled by default.

### Windows and panes

- `prefix + c` — create a window in the current directory.
- `prefix + h` — split vertically with the new pane below.
- `prefix + v` — split horizontally with the new pane on the right.
- `prefix + Space` — switch to the last window.
- `prefix + b` — break the current pane into a new window.
- `prefix + x` — kill the current pane without confirmation.
- `prefix + z` — toggle pane zoom.
- `prefix + y` — toggle synchronized panes.

### Navigation

- `Alt + Arrow` — move between panes.
- `Shift + Left/Right` — move to the previous or next window.
- `Ctrl + Shift + Left/Right` — move the current window.

### Resizing

Hold the prefix while pressing the following keys to resize by five cells:

- `prefix + H` — resize left.
- `prefix + J` — resize down.
- `prefix + K` — resize up.
- `prefix + L` — resize right.

### Reloading

- `prefix + r` — reload this configuration.

## Copy mode

Copy mode uses Vim-style keys. Press `v` in copy mode to begin selecting text.

## Theme and status bar

The status bar sits at the bottom and uses the Catppuccin Macchiato palette — the same flavor the starship prompt uses — loaded from `themes/catppuccin_macchiato.conf` (copied from [catppuccin/tmux](https://github.com/catppuccin/tmux) v2.3.1). Colors in `tmux.conf` reference the palette via `#{@thm_*}` placeholders instead of hardcoded hex values. The status bar shows the current session, window information, time, date, user, and host. A Nerd Font is recommended for the status icons.

## Customization

Edit `tmux.conf` to change shared behavior. Keep machine-specific changes in separate local configuration when possible so the shared dotfiles remain portable.
