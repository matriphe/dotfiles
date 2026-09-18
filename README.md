# dotfiles

This repository holds Muhammad Zamroni's personal dotfiles, shell, terminal, and application configuration. It also contains shared AI-agent guidelines for Codex, Claude Code, Gemini, Antigravity, OpenCode, and Cursor. The configuration is intended to provide a simple, reproducible starting point for a personal development environment.

The repository is intended to be checked out as a bare Git repository from the home directory. The repository's working tree is therefore `$HOME` (`~`), so its root directory becomes the home directory and the tracked files are available at paths such as `~/AGENTS.md` and `~/.config/zsh`.

At the time this configuration was created, it was running on Fedora Workstation 44 with Zsh.

## TL;DR

This is the quick Fedora installation. Read the sections below for the preparation details and configuration-specific instructions.

```sh
sudo dnf install -y zsh tmux eza bat ripgrep podman podman-compose
sudo dnf copr enable -y pennbauman/ports
sudo dnf install -y lf
sudo dnf copr enable -y atim/starship
sudo dnf install -y starship
```

Install [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts), then clone and check out the repository into `$HOME`:

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f

cd ~
git clone --bare https://github.com/matriphe/dotfiles.git .dotfiles
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

After the first checkout, load the Zsh configuration to enable the `dotfiles` alias:

```sh
source "$HOME/.config/zsh/.zshrc"
```

You can also start a new Zsh session instead of sourcing the file manually.

## Setup

This section covers the preparation steps, required tools, and application installation. The commands use Fedora's DNF package manager because this configuration was created and tested on Fedora Workstation 44. Other operating systems may require different installation commands.

Create the data directory used by the Nerd Fonts installation:

```sh
mkdir -p "$HOME/.local/share"
```

### Zsh

Install Zsh with DNF (Fedora):

```sh
sudo dnf install -y zsh
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
sudo dnf install -y tmux
```

Tmux is a terminal multiplexer that lets you run multiple terminal sessions and panes in one window. It is needed for the Tmux configuration in this repo.

The Tmux configuration is stored at [`$HOME/.config/tmux/tmux.conf`](.config/tmux/tmux.conf) and is loaded automatically by Tmux from its XDG configuration path.

### Eza

Install eza with DNF (Fedora):

```sh
sudo dnf install -y eza
```

[Eza](https://github.com/eza-community/eza) is a modern replacement for `ls`. It is needed by the `ls`, `ll`, `la`, and `tree` aliases.

### Bat

Install bat with DNF (Fedora):

```sh
sudo dnf install -y bat
```

[Bat](https://github.com/sharkdp/bat) is a `cat` replacement with syntax highlighting. It is needed by the `cat` alias.

### Ripgrep

Install ripgrep with DNF (Fedora):

```sh
sudo dnf install -y ripgrep
```

[Ripgrep](https://github.com/BurntSushi/ripgrep) is a fast replacement for `grep`. It is needed by the `grep` alias.

### Lf

Install lf with DNF (Fedora):

```sh
sudo dnf copr enable -y pennbauman/ports
sudo dnf install -y lf
```

[Lf](https://github.com/gokcehan/lf) is a terminal file manager. It is needed by the `lf` navigation function. Fedora does not include `lf` in its standard repositories, so this installation uses the community-maintained [pennbauman/ports COPR](https://copr.fedorainfracloud.org/coprs/pennbauman/ports/).

### Nerd Fonts

Nerd Fonts provide the icons and glyphs used by the Starship prompt. This configuration uses [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts), but you can use another available Nerd Font such as JetBrainsMono Nerd Font.

Install Hack Nerd Font for the current user:

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f
```

Select `Hack Nerd Font` in your terminal emulator. To use another font, replace `Hack.tar.xz` with the matching archive from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

### Starship

Install Starship with DNF (Fedora):

```sh
sudo dnf copr enable -y atim/starship
sudo dnf install -y starship
```

[Starship](https://github.com/starship/starship) is the shell prompt used by this configuration.

### Podman

Install Podman and podman-compose with DNF (Fedora):

```sh
sudo dnf install -y podman podman-compose
```

[Podman](https://podman.io/) is a container engine. Fedora uses Podman by default instead of Docker.

[Podman Compose](https://github.com/containers/podman-compose) provides Compose-compatible commands. The Podman module maps `docker` to `podman` and `docker-compose` to `podman-compose`.

### Core Utilities

`git`, `nano`, `less`, `diff`, `df`, `mktemp`, `cat`, `rm`, and similar shell/core utilities are commonly available on major Linux distributions and macOS, so they do not need separate installation instructions.

## Clone and Install This Repository

Clone this repository as a bare repository and use the home directory as its working tree:

```sh
cd ~
git clone --bare https://github.com/matriphe/dotfiles.git .dotfiles
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

After the first checkout, load the Zsh configuration to enable the `dotfiles` alias:

```sh
source "$HOME/.config/zsh/.zshrc"
```

You can also start a new Zsh session instead of sourcing the file manually.

The checkout places the tracked files directly in the home directory. The repository root becomes `$HOME` (`~`), so files such as `AGENTS.md`, `.config/zsh`, and `.config/tmux` are available at their normal home-directory paths. The bare Git repository itself is stored separately at `~/.dotfiles`.

### Manage the dotfiles repository

The Zsh configuration provides a `dotfiles` alias for the bare repository. It uses `~/.dotfiles` as the Git directory and `$HOME` as the working tree, so regular Git commands can be run through the alias:

```sh
dotfiles status
dotfiles checkout
dotfiles add .config/zsh/aliases.zsh
dotfiles commit -m "Update Zsh aliases"
dotfiles push
```

Run these commands from `$HOME` when using relative paths. The alias is loaded from [`$HOME/.config/zsh/aliases.zsh`](.config/zsh/aliases.zsh) by the Zsh configuration.

## AI Agent Configuration

The shared AI agent guidelines are stored in [`$HOME/AGENTS.md`](AGENTS.md). The file contains the common rules used by all AI agents in this configuration.

The agent-specific files point to the shared guidelines:

- `$HOME/.codex/AGENTS.md` is used by Codex.
- `$HOME/.claude/CLAUDE.md` is used by Claude Code.
- `$HOME/.gemini/GEMINI.md` is used by Gemini CLI and Google Antigravity.
- `$HOME/.config/opencode/opencode.json` loads the guidelines for OpenCode.
- `$HOME/.cursor/rules/ai-guidelines.mdc` is used by Cursor.
- `$HOME/.agents/rules/ai-guidelines.md` is used by Google Antigravity for workspace rules.

These files keep the agent-specific configuration small while using [`$HOME/AGENTS.md`](AGENTS.md) as the single source of truth. The `.config` directory is reserved for application and shell configuration; the root-level `AGENTS.md` contains the shared AI-agent guidance.

## Credits

This repository is inspired by [Radley Lewis's dotfiles](https://github.com/radleylewis/dotfiles).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
