# dotfiles

This repository holds Muhammad Zamroni's dotfiles and configuration. It may change over time as his setup evolves.

## Environment

At the time this configuration was created, it was running on Fedora 44 with
Zsh and was tested on Fedora 44.

### Requirements

- `sudo` access
- Zsh

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
