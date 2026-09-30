# dotfiles

This repository contains Muhammad Zamroni's personal dotfiles, shell, terminal, and application configuration. It also contains shared AI-agent guidelines for Codex, Claude Code, Gemini, Antigravity, OpenCode, and Cursor. The configuration provides a simple, reproducible starting point for a personal development environment.

The repository is checked out as a bare Git repository from the home directory. Its working tree is therefore `$HOME` (`~`), so the repository root becomes the home directory and tracked files are available at paths such as `~/AGENTS.md` and `~/.config/zsh`.

This configuration was created and tested on Fedora Workstation 44 with Zsh.

## Table of contents

- [Zsh](#zsh)
  - [Install Zsh](#install-zsh)
  - [Configure Zsh](#configure-zsh)
  - [Zsh modules](#zsh-modules)
- [Setup](#setup)
  - [Install the required tools](#install-the-required-tools)
  - [Configure Antidote](#configure-antidote)
  - [Install a Nerd Font](#install-a-nerd-font)
  - [Container runtime](#container-runtime)
- [Clone and install this repository](#clone-and-install-this-repository)
  - [Manage the dotfiles repository](#manage-the-dotfiles-repository)
- [AI agent configuration](#ai-agent-configuration)
- [Component documentation](#component-documentation)
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

On macOS, use the same approach as Fedora: create `/etc/zshenv` with the block below. Zsh reads `/etc/zshenv` in every shell — interactive, login, and non-interactive — before the `.zshenv` stage, so `$ZDOTDIR/.zshenv` and `$ZDOTDIR/.zshrc` always load with `ZDOTDIR` already set.

Do not put the block in `/etc/zshrc`: that file only runs for interactive shells, which is too late for the `.zshenv` stage and leaves non-interactive shells without `ZDOTDIR`.

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

### Zsh modules

The files in [`.config/zsh/modules`](.config/zsh/modules) are loaded automatically by `.zshrc` after the shared aliases and plugins. They keep optional integrations separate from the core shell configuration:

- [`homebrew.zsh`](.config/zsh/modules/homebrew.zsh) initializes Homebrew when it is installed, including the standard `/opt/homebrew` and `/usr/local` locations on macOS.
- [`podman.zsh`](.config/zsh/modules/podman.zsh) maps `docker` to `podman` and `docker-compose` to `podman-compose` only when both Podman commands are available. It also disables Podman Compose's warning log output.

Modules are loaded only when their files are present, so optional tools can be installed or omitted without changing the main Zsh startup files.

## Setup

This section covers the required tools and platform-specific configuration steps.

The commands below are grouped by operating system because package names, package managers, and system-wide Zsh configuration paths differ.

### Install the required tools

| Tool | Purpose |
| --- | --- |
| [Git](https://git-scm.com/) | Clones and manages this repository as a bare repository. |
| [curl](https://curl.se/) | Downloads installation files and release assets. |
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
sudo dnf install -y git curl tmux eza bat ripgrep podman podman-compose
sudo dnf copr enable -y pennbauman/ports
sudo dnf install -y lf
sudo dnf copr enable -y atim/starship
sudo dnf install -y starship
```

Fedora uses the `pennbauman/ports` COPR because `lf` is not in the standard repositories. It uses the `atim/starship` COPR for Starship. Podman is the recommended Fedora container engine.

#### Debian/Ubuntu

Install the required packages with APT:

```sh
sudo apt update
sudo apt install -y git curl zsh tmux eza bat ripgrep lf starship
```

Antidote is installed separately in [Configure Antidote](#configure-antidote), and Hack Nerd Font is installed in [Install a Nerd Font](#install-a-nerd-font). If your Debian or Ubuntu release does not provide `eza` or `starship`, install those tools using their upstream instructions: [Eza](https://github.com/eza-community/eza) and [Starship](https://starship.rs/install/).

#### macOS

Install with Homebrew. Antidote itself is better installed from source (see [Configure Antidote](#configure-antidote)), so it is left out here:

```sh
brew install git curl tmux eza bat ripgrep lf starship
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

On macOS, install Antidote the same way as on Fedora — from source. This is the recommended setup: it keeps both the loader and the plugin clones inside `$XDG_DATA_HOME/zsh/antidote`, so Homebrew upgrades cannot wipe the plugins.

```sh
mkdir -p "$HOME/.local/share/zsh"
git clone --depth=1 https://github.com/mattmc3/antidote.git \
  "$HOME/.local/share/zsh/antidote"
```

As an alternative, Antidote can be installed with Homebrew:

```sh
brew install antidote
```

With Homebrew, the configuration automatically finds the loader under the Homebrew prefix (`/opt/homebrew` or `/usr/local`) on macOS; no symlink is needed. Note that the loader then lives inside the Homebrew Cellar — do not point `ANTIDOTE_HOME` (or a symlink) at the Homebrew installation, because every `brew upgrade antidote` replaces that path and would break the plugin clones.

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

Install Fontconfig first so the `fc-cache` command is available:

```sh
sudo apt update
sudo apt install -y fontconfig
```

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f -v "$HOME/.local/share/fonts"
```

If `fc-cache` is still unavailable after installing `fontconfig`, open a new shell or run `hash -r` so the shell refreshes its command lookup. Verify the installation with `fc-list | grep -i 'Hack Nerd Font'`.

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

Debian and Ubuntu do not include Docker by default. First configure Docker's official APT repository by following the distribution-specific instructions in the [Docker Engine installation guide](https://docs.docker.com/engine/install/). Then install Docker Engine and the Docker Compose plugin:

```sh
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo docker run hello-world
docker compose version
```

The official package is `docker-compose-plugin`, which provides the `docker compose` command. The standalone `docker-compose` package is legacy.

#### macOS

On macOS, use [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Colima](https://github.com/abiosoft/colima) instead.

With Docker Desktop, `docker` and `docker-compose` are bundled in one application. Install it from the link above and enable the Docker CLI in its settings. The Podman module does not override these commands unless both `podman` and `podman-compose` are installed.

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
dotfiles update-force
dotfiles reload
```

`dotfiles update` pulls the latest upstream changes with fast-forward-only behavior. Files whose local content is already identical to the upstream version are reset automatically so they do not block the update; genuine local edits are kept and listed if they would be overwritten.

`dotfiles update-force` resets every tracked file in `$HOME` to the repository state, discarding local changes to tracked files. It asks for confirmation first; pass `-y` to skip it (`dotfiles update-force -y`). Use it when the work tree has drifted from the repository and a normal update refuses to proceed. Skip-worktree files are left untouched.

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

## Component documentation

Each major configuration has a focused README with its startup behavior, available features, and customization points:

- [Zsh configuration](.config/zsh/README.md)
- [Starship prompt](.config/starship/README.md)
- [Tmux configuration](.config/tmux/README.md)

## Credits

This repository is inspired by [Radley Lewis's dotfiles](https://github.com/radleylewis/dotfiles).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
