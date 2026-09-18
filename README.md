# dotfiles

This repository holds Muhammad Zamroni's dotfiles and configuration. It may change over time as his setup evolves.

## Requirements

At the time this configuration was created, it was running on Fedora Workstation 44 with Zsh.

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
    export XDG_CONFIG_HOME="$HOME/.config/"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    # ZDOTDIR tells Zsh where to find startup files such as .zshrc.
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
fi
```

Log out from the shell and back in for the change to take effect.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
