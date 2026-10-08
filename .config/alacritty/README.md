# Alacritty Configuration

This directory contains the [Alacritty](https://alacritty.org/) terminal
emulator configuration used by this dotfiles repository.

## How it works

Alacritty loads this configuration from
`$XDG_CONFIG_HOME/alacritty/alacritty.toml`, which the `.zshenv` in this
repository sets to `$HOME/.config/alacritty/alacritty.toml`. The path is found
whether or not `XDG_CONFIG_HOME` is exported, because Alacritty searches
`$HOME/.config/alacritty/alacritty.toml` when it is unset.

On Windows, Alacritty reads `%APPDATA%\alacritty\alacritty.toml` instead, so
this file does not apply there.

## Font

The configuration uses Hack Nerd Font at size 12, with explicit regular, bold,
italic, and bold italic styles. The Nerd Font supplies the glyphs that the
Starship prompt and tmux status bar use; install it using the instructions in
the root README before starting Alacritty.

Alacritty falls back to the normal font family for the bold, italic, and bold
italic faces when those entries omit `family`, so a different family for each
style is optional. This configuration names Hack Nerd Font in all four entries
so every face comes from the same family.

## Terminal environment

The `[env]` section sets `TERM` to `xterm-256color`. Alacritty normally prefers
its own `alacritty` terminfo entry when one is installed, and falls back to
`xterm-256color` when it is not. Setting the value explicitly keeps the
environment identical across machines, so remote shells and the tmux
configuration see the same terminal type.

The tmux configuration also sets `default-terminal` to `xterm-256color` and
enables true color for `xterm*` and `alacritty*` terminals.

## Theme

The theme is Catppuccin Macchiato, matching the tmux theme in
[`themes/catppuccin_macchiato.conf`](../tmux/themes/catppuccin_macchiato.conf)
and the Starship palette (`palette = 'catppuccin_macchiato'`). The `[colors]`
tables are copied from [catppuccin/alacritty](https://github.com/catppuccin/alacritty),
so the terminal background, text, cursor, selection, and the 16 ANSI colors
match the rest of the configuration.

## Window

Window decorations use the full title bar and borders.

## Customization

Edit `alacritty.toml` to change the font, colors, window behavior, and
key bindings. See the [Alacritty configuration
documentation](https://alacritty.org/config-alacritty.html) for the available
options. Changes apply when a new Alacritty window is opened; Alacritty reloads
the configuration automatically on live reload for the running instance when
the file changes.
