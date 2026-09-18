# Starship Configuration

This directory contains the [Starship](https://starship.rs/) prompt configuration used by this dotfiles repository.

## How it works

The Zsh Starship module sets `STARSHIP_CONFIG` to `$XDG_CONFIG_HOME/starship/starship.toml` and initializes Starship for Zsh.

## Prompt features

The prompt displays:

- The current directory and common directory icons.
- Git branch and repository status.
- PHP, Go, Python, and Rust versions when applicable.
- Command duration and local IP address.
- The current operating system and user.
- A Fedora-inspired colour palette.

The prompt uses Nerd Font glyphs for its icons. Hack Nerd Font is the selected font for this configuration, but another compatible Nerd Font can be used.

## Customization

Edit `starship.toml` to change the prompt layout, colours, symbols, or enabled modules. See the [Starship configuration documentation](https://starship.rs/config/) for the available options.
