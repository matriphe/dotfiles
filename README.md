# dotfiles

This repository contains Muhammad Zamroni's personal dotfiles, shell, terminal, and application configuration. It also contains shared AI-agent guidelines for Codex, Claude Code, Gemini, Antigravity, OpenCode, and Cursor. The configuration provides a simple, reproducible starting point for a personal development environment.

The repository is checked out as a bare Git repository from the home directory. Its working tree is therefore `$HOME` (`~`), so the repository root becomes the home directory and tracked files are available at paths such as `~/AGENTS.md` and `~/.config/zsh`.

This configuration was created and tested on Fedora Workstation 44 with Zsh.

## Table of contents

- [Zsh](#zsh)
  - [Install Zsh](#install-zsh)
  - [Configure Zsh](#configure-zsh)
- [Setup](#setup)
  - [Install the required tools](#install-the-required-tools)
  - [Configure Antidote](#configure-antidote)
  - [Install a Nerd Font](#install-a-nerd-font)
  - [Container runtime](#container-runtime)
- [Clone and install this repository](#clone-and-install-this-repository)
  - [Manage the dotfiles repository](#manage-the-dotfiles-repository)
- [AI agent configuration](#ai-agent-configuration)
- [Credits](#credits)
- [License](#license)

## Zsh

### Install Zsh

#### Fedora

Install Zsh using the package manager:

```sh
sudo dnf install -y zsh
```

Then set Zsh as the default shell:

```sh
chsh -s "$(command -v zsh)"
```

#### Debian/Ubuntu

Install Zsh using APT:

```sh
sudo apt update
sudo apt install -y zsh
```

Then set Zsh as the default shell:

```sh
chsh -s "$(command -v zsh)"
```

#### macOS

On macOS, Zsh is the default shell, so no installation is needed.

### Configure Zsh

Configure the global Zsh startup file to use `$HOME/.config/zsh`.

#### Fedora

On Fedora, the global configuration file is `/etc/zshenv`. Create it if it does not exist, or append the block below if it does:

```sh
sudo tee -a /etc/zshenv > /dev/null <<'EOF'

# Dotfiles (https://github.com/matriphe/dotfiles)
if [[ -z "$XDG_CONFIG_HOME" ]]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    # ZDOTDIR tells Zsh where to find startup files such as .zshrc.
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
EOF
```

Then log out from the shell and back in for the change to take effect.

#### Debian/Ubuntu

On Debian and Ubuntu, the global configuration file is `/etc/zsh/zshenv`. Create it if it does not exist, or append the block below if it does:

```sh
sudo tee -a /etc/zsh/zshenv > /dev/null <<'EOF'

# Dotfiles (https://github.com/matriphe/dotfiles)
if [[ -z "$XDG_CONFIG_HOME" ]]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    # ZDOTDIR tells Zsh where to find startup files such as .zshrc.
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
EOF
```

Then log out from the shell and back in for the change to take effect.

#### macOS

On macOS, the global Zsh configuration file is `/etc/zshrc`, which already exists and is managed by Apple.

Append the block below to the end of the file, after the last line, so Apple's defaults stay intact and these exports take precedence:

```sh
sudo tee -a /etc/zshrc > /dev/null <<'EOF'

# Dotfiles (https://github.com/matriphe/dotfiles)
if [[ -z "$XDG_CONFIG_HOME" ]]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    # ZDOTDIR tells Zsh where to find startup files such as .zshrc.
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
EOF
```

Then log out from the shell and back in for the change to take effect.

## Setup

This section covers the required tools and platform-specific configuration steps.

The commands below are grouped by operating system because package names, package managers, and system-wide Zsh configuration paths differ.

### Install the required tools

| Tool | Purpose |
| --- | --- |
| [Git](https://git-scm.com/) | Clones and manages this repository as a bare repository. |
| [Zsh](https://www.zsh.org/) | Shell used by this configuration. |
| [Tmux](https://github.com/tmux/tmux) | Terminal multiplexer used by the Tmux configuration. |
| [Antidote](https://antidote.sh/) | Installs and loads the Zsh plugins listed in `.zsh_plugins.txt`. |
| [Eza](https://github.com/eza-community/eza) | Modern `ls` replacement used by the `ls`, `ll`, `la`, and `tree` aliases. |
| [Bat](https://github.com/sharkdp/bat) | Syntax-highlighting `cat` replacement used by the `cat` alias. |
| [Ripgrep](https://github.com/BurntSushi/ripgrep) | Fast standalone search tool; `grep` remains the system command because its flags differ. |
| [Lf](https://github.com/gokcehan/lf) | Terminal file manager used by the `lf` navigation function. |
| [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts) | Provides the icons and glyphs used by the Starship prompt. |
| [Starship](https://starship.rs/) | Shell prompt used by this configuration. |
| Podman / Docker | Container engine used by the Docker-compatible aliases. |

#### Fedora

Install with DNF:

```sh
sudo dnf install -y tmux eza bat ripgrep podman podman-compose
sudo dnf copr enable -y pennbauman/ports
sudo dnf install -y lf
sudo dnf copr enable -y atim/starship
sudo dnf install -y starship
```

Fedora uses the `pennbauman/ports` COPR because `lf` is not in the standard repositories. It uses the `atim/starship` COPR for Starship. Podman is the recommended Fedora container engine.

#### Debian/Ubuntu

Install the required tools with APT:

```sh
sudo apt update
sudo apt install -y ca-certificates curl fontconfig git lf ripgrep tmux \
  eza bat starship podman podman-compose
```

On Debian-based systems, the `bat` executable may be installed as `batcat`. If the `cat` alias cannot find `bat`, create a user-level compatibility link:

```sh
mkdir -p "$HOME/.local/bin"
if command -v batcat > /dev/null 2>&1 && ! command -v bat > /dev/null 2>&1
then
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
fi
```

If a package is unavailable in the enabled repositories, enable the distribution's `universe`/equivalent repository or follow the installation instructions from the tool's project page.

#### macOS

Install with Homebrew:

```sh
brew install tmux eza bat ripgrep lf starship antidote
brew install --cask font-hack-nerd-font
```

### Configure Antidote

This configuration uses [Antidote](https://antidote.sh/) to manage Zsh plugins.

The loaded plugins are listed in [`.config/zsh/.zsh_plugins.txt`](.config/zsh/.zsh_plugins.txt):

- [`zsh-users/zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) displays suggestions from your command history as you type.
- [`zsh-users/zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) highlights valid and invalid shell syntax before a command runs.
- [`zsh-users/zsh-history-substring-search`](https://github.com/zsh-users/zsh-history-substring-search) searches command history using the text currently entered at the prompt.

Antidote reads the manifest and generates a cached plugin bundle, so normal shell startup does not perform Git operations. Update the installed plugins and regenerate the bundle with:

```zsh
zsh-plugins-update
```

#### Fedora

Install it manually for the current user:

```sh
mkdir -p "$HOME/.local/share/zsh"
git clone --depth=1 https://github.com/mattmc3/antidote.git \
  "$HOME/.local/share/zsh/antidote"
```

#### Debian/Ubuntu

Install Antidote manually for the current user:

```sh
mkdir -p "$HOME/.local/share/zsh"
git clone --depth=1 https://github.com/mattmc3/antidote.git \
  "$HOME/.local/share/zsh/antidote"
```

#### macOS

On macOS, Antidote can be installed with Homebrew instead:

```sh
brew install antidote
```

Homebrew places Antidote under the Homebrew prefix, while the configuration loads it from `$XDG_DATA_HOME/zsh/antidote`. Symlink the Homebrew installation to the expected path so the configuration works unchanged:

```sh
mkdir -p "$HOME/.local/share/zsh"
ln -s "$(brew --prefix)/opt/antidote/share/antidote" "$HOME/.local/share/zsh/antidote"
```

### Install a Nerd Font

Nerd Fonts provide the icons and glyphs used by the Starship prompt. This configuration uses [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts), but you can use another available Nerd Font such as JetBrainsMono Nerd Font.

Install Hack Nerd Font for the current user using the instructions for your platform:

#### Fedora

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f
```

Select `Hack Nerd Font` in your terminal emulator. To use another font, replace `Hack.tar.xz` with the matching archive from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

#### Debian/Ubuntu

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f
```

Select `Hack Nerd Font` in your terminal emulator. To use another font, replace `Hack.tar.xz` with the matching archive from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

#### macOS

On macOS, install Hack Nerd Font with Homebrew's font casks:

```sh
brew install --cask font-hack-nerd-font
```

### Container runtime

A container engine is required by the Docker-compatible aliases in the Zsh configuration.

#### Fedora

On Fedora, [Podman](https://podman.io/) is the default container engine and is usually preinstalled. Install Podman and Podman Compose if they are not already installed:

```sh
sudo dnf install -y podman podman-compose
```

[Podman Compose](https://github.com/containers/podman-compose) provides Compose-compatible commands. The Podman module maps `docker` to `podman` and `docker-compose` to `podman-compose`.

#### Debian/Ubuntu

Install Podman and Podman Compose if they are not already installed:

```sh
sudo apt update
sudo apt install -y podman podman-compose
```

[Podman Compose](https://github.com/containers/podman-compose) provides Compose-compatible commands. The Podman module maps `docker` to `podman` and `docker-compose` to `podman-compose`.

#### macOS

On macOS, use [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Colima](https://github.com/abiosoft/colima) instead.

With Docker Desktop, `docker` and `docker-compose` are bundled in one application. Install it from the link above and enable the Docker CLI in its settings.

With Colima, install the Docker CLI, the standalone Compose binary, and Colima itself, then start the virtual machine:

```sh
brew install docker docker-compose colima
colima start
```

Homebrew installs the standalone `docker-compose` binary outside the Docker CLI plugin path. Link it into the CLI plugin directory so the `docker compose` subcommand works:

```sh
mkdir -p "$HOME/.docker/cli-plugins"
ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-compose" "$HOME/.docker/cli-plugins/docker-compose"
```

## Clone and install this repository

Clone this repository as a bare repository and use your home directory as its working tree:

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

The checkout places tracked files directly in the home directory. The repository root becomes `$HOME` (`~`), so files such as `AGENTS.md`, `.config/zsh`, and `.config/tmux` are available at their normal home-directory paths. The bare Git repository itself is stored separately at `~/.dotfiles`.

### Manage the dotfiles repository

The Zsh configuration provides a `dotfiles` helper for the bare repository. It uses `~/.dotfiles` as the Git directory and `$HOME` as the working tree, so you can run regular Git commands through the helper:

```sh
dotfiles status
dotfiles checkout
dotfiles add .config/zsh/aliases.zsh
dotfiles commit -m "Update Zsh aliases"
dotfiles push
dotfiles update
dotfiles reload
```

`dotfiles update` pulls the latest upstream changes with fast-forward-only behavior. Use `dotfiles commit` and `dotfiles push` to commit and publish your local changes.

`dotfiles reload` reloads both `.zshenv` and `.zshrc` in the current Zsh shell after configuration changes.

Run these commands from `$HOME` when using relative paths. The Zsh configuration loads the helper from [`$HOME/.config/zsh/aliases.zsh`](.config/zsh/aliases.zsh).

## AI agent configuration

The shared AI-agent guidelines are stored in [`~/AGENTS.md`](AGENTS.md). This file contains the common rules used by all AI agents in this configuration.

The agent-specific files point to the shared guidelines:

- `$HOME/.codex/AGENTS.md` references `~/AGENTS.md` for Codex.
- `$HOME/.copilot/copilot-instructions.md` references `~/AGENTS.md` for GitHub Copilot.
- `$HOME/.claude/CLAUDE.md` imports `~/AGENTS.md` for Claude Code.
- `$HOME/.gemini/GEMINI.md` imports `~/AGENTS.md` for Gemini CLI and Google Antigravity.
- `$HOME/.config/opencode/opencode.json` loads `~/AGENTS.md` for OpenCode.
- `$HOME/.cursor/rules/ai-guidelines.mdc` references `~/AGENTS.md` for Cursor.
- `$HOME/.agents/rules/ai-guidelines.md` references `~/AGENTS.md` for Google Antigravity workspace rules.

These files keep the agent-specific configuration small while using [`~/AGENTS.md`](AGENTS.md) as the single source of truth. The `.config` directory is reserved for application and shell configuration, while the root-level `AGENTS.md` contains the shared AI-agent guidance.

## Credits

This repository is inspired by [Radley Lewis's dotfiles](https://github.com/radleylewis/dotfiles).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
