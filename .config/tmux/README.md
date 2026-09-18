# Tmux Configuration

This directory contains the Tmux configuration used by this dotfiles repository. Tmux automatically loads `tmux.conf` from `$XDG_CONFIG_HOME/tmux/tmux.conf`.

This configuration is inspired by [Radley Lewis's Tmux configuration](https://github.com/radleylewis/dotfiles/blob/master/.config/tmux/tmux.conf).

## Prefix

The default Tmux prefix is `Ctrl-b`. `Ctrl-B` is also configured as a secondary prefix.

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

The configuration uses a Melange-inspired colour palette with the status bar at the top. The status bar shows the current session, window information, time, date, user, and host. A Nerd Font is recommended for the status icons.

## Customization

Edit `tmux.conf` to change shared behavior. Keep machine-specific changes in separate local configuration when possible so the shared dotfiles remain portable.

## Credits

This configuration is inspired by [Radley Lewis's Tmux configuration](https://github.com/radleylewis/dotfiles/blob/master/.config/tmux/tmux.conf).
