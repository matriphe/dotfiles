# dotfiles

This repository holds Muhammad Zamroni's dotfiles and configuration. It may change over time as his setup evolves.

At the time this configuration was created, it was running on Fedora Workstation 44 with Zsh.

## Setup

Clone this repository.

```sh
cd ~
git clone --bare https://github.com/matriphe/dotfiles.git .dotfiles
```

The checkout creates the tracked `.config` directory and its configuration files in your home directory.

Create the non-repository directories used by `.config/zsh/.zshenv`:

```sh
mkdir -p \
  "$HOME/.cache" \
  "$HOME/.local/share" \
  "$HOME/.local/state"
```

### Zsh

Install Zsh with DNF (Fedora):

```sh
sudo dnf install zsh
```

Set Zsh as the default shell:

```sh
chsh -s "$(command -v zsh)"
```

Update the global Zsh configuration to point to `.config/zsh`. On Fedora, it is `/etc/zshenv`.

```sh
sudoedit /etc/zshenv
```

Add the following:

```zsh
if [[ -z "$XDG_CONFIG_HOME" ]]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    # ZDOTDIR tells Zsh where to find startup files such as .zshrc.
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

Log out from the shell and back in for the change to take effect.

### Tmux

Install Tmux with DNF (Fedora):

```sh
sudo dnf install tmux
```

The Tmux configuration is stored at `.config/tmux/tmux.conf` and is loaded automatically when starting Tmux from Zsh.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
