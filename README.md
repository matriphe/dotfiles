# dotfiles

This repository holds Muhammad Zamroni's dotfiles and configuration. It may change over time as his setup evolves.

## Environment

At the time this configuration was created, it was running on Fedora 44 with
Zsh and was tested on Fedora 44.

### Requirements

- `sudo` access
- Zsh

### Preparation

Before using this configuration, add the following to the system-wide Zsh
environment file. On Fedora, this file is `/etc/zshenv`; other systems may use
a different path. This is a one-time setup step and requires `sudo`:

```sh
sudoedit /etc/zshenv
```

Add:

```zsh
if [[ -z "$XDG_CONFIG_HOME" ]]
then
    export XDG_CONFIG_HOME="$HOME/.config/"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    # ZDOTDIR tells Zsh where to find startup files such as .zshrc.
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
fi
```

### Installation

Install Zsh with DNF:

```sh
sudo dnf install zsh
```

Set Zsh as the default shell:

```sh
chsh -s "$(command -v zsh)"
```

Log out and back in for the change to take effect.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
