# dotfiles

Personal dotfiles for Zsh, terminal, application, and AI-agent configuration.

Check out this repository as a bare Git repository from `$HOME` (`~`). Follow
the platform-specific setup instructions to install the tools and apply the
configuration.

## Table of contents

- [Zsh](#zsh)
  - [Install Zsh](#install-zsh)
  - [Configure Zsh](#configure-zsh)
  - [Zsh modules](#zsh-modules)
- [Setup](#setup)
  - [Install the required tools](#install-the-required-tools)
  - [Install Antidote](#install-antidote)
  - [Install Starship](#install-starship)
  - [Install Nerd Font](#install-nerd-font)
  - [Install Podman/Docker](#install-podmandocker)
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

#### Debian, Ubuntu, and Linux Mint

Linux Mint uses Ubuntu as its package base, while Linux Mint Debian Edition
(LMDE) uses Debian. All of these distributions use APT.

Install Zsh using APT:

```sh
sudo apt install -y zsh
```

#### macOS

On macOS, Zsh is the default shell, so no installation is needed.

### Configure Zsh

Configure the global Zsh startup file to use `$HOME/.config/zsh`.

On Linux, the first launch may display the `zsh-newuser-install` configuration
menu because no startup files exist. Select `q` when it shows:

```text
(q) Quit and do nothing. The function will be run again next time.
```

This avoids creating a generated Zsh configuration; see the [official Zsh
documentation](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html)
for details. Then set Zsh as the default shell:

```sh
chsh -s "$(command -v zsh)"
```

#### Fedora and macOS

On Fedora and macOS, the global configuration file is `/etc/zshenv`. Create it
if it does not exist, or append the block below if it does:

On macOS, Zsh reads `/etc/zshenv` in every shell — interactive, login, and
non-interactive — before the `.zshenv` stage, so `$ZDOTDIR/.zshenv` and
`$ZDOTDIR/.zshrc` always load with `ZDOTDIR` already set. Do not put the block
in `/etc/zshrc`: that file only runs for interactive shells, which is too late
for the `.zshenv` stage and leaves non-interactive shells without `ZDOTDIR`.

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

#### Debian, Ubuntu, and Linux Mint

On Debian, Ubuntu, and Linux Mint, the global configuration file is `/etc/zsh/zshenv`. Create it if it does not exist, or append the block below if it does:

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

Log out from the shell and back in after updating the global configuration.

### Zsh modules

Use the files in [`.config/zsh/modules`](.config/zsh/modules) for optional integrations. `.zshrc` loads them after the shared aliases and plugins:

- [`homebrew.zsh`](.config/zsh/modules/homebrew.zsh) initializes Homebrew when it is installed, including the standard `/opt/homebrew` and `/usr/local` locations on macOS.
- [`podman.zsh`](.config/zsh/modules/podman.zsh) maps `docker` to `podman` and `docker-compose` to `podman-compose` when both Podman commands are available. It also disables Podman Compose's warning log output.

Add or remove module files as needed; `.zshrc` loads only modules that are present.

## Setup

Install the required tools and complete the platform-specific configuration steps below. The commands are grouped by operating system because package names, package managers, and system-wide Zsh configuration paths differ.

### Install the required tools

| Tool | Purpose |
| --- | --- |
| [Git](https://git-scm.com/) | Clone and manage this repository as a bare repository. |
| [curl](https://curl.se/) | Download installation files and release assets. |
| [Zsh](https://www.zsh.org/) | Run the configured shell. |
| [Tmux](https://github.com/tmux/tmux) | Run the configured terminal multiplexer. |
| [Antidote](https://antidote.sh/) | Install and load the Zsh plugins listed in `.zsh_plugins.txt`; configure it in [Install Antidote](#install-antidote). |
| [Eza](https://github.com/eza-community/eza) | Replace `ls` with the `ls`, `ll`, `la`, and `tree` aliases. |
| [Bat](https://github.com/sharkdp/bat) | Replace `cat` with syntax highlighting through the `cat` alias. |
| [Ripgrep](https://github.com/BurntSushi/ripgrep) | Search quickly with a standalone tool; keep `grep` for its different flags. |
| [Lf](https://github.com/gokcehan/lf) | Browse files through the `lf` navigation function. |
| [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts) | Provide the icons and glyphs used by the Starship prompt; install it in [Install Nerd Font](#install-nerd-font). |
| [Starship](https://starship.rs/) | Display the configured shell prompt; install it in [Install Starship](#install-starship). |
| Podman / Docker | Provide the container engine; install it in [Install Podman/Docker](#install-podmandocker). |

#### Fedora

Install with DNF:

```sh
sudo dnf install -y git curl tmux eza bat ripgrep
sudo dnf copr enable -y pennbauman/ports
sudo dnf install -y lf
```

Enable the `pennbauman/ports` COPR to install `lf`, which is not in Fedora's standard repositories. Use Podman as the recommended Fedora container engine.

#### Debian, Ubuntu, and Linux Mint

Install the required packages with APT:

```sh
sudo apt install -y git curl zsh tmux eza bat ripgrep lf
```

Install Antidote separately in [Install Antidote](#install-antidote), and install Hack Nerd Font in [Install Nerd Font](#install-nerd-font). If your release does not provide `eza`, follow the upstream instructions for [Eza](https://github.com/eza-community/eza).

#### macOS

Install the tools with Homebrew:

```sh
brew install git curl tmux eza bat ripgrep lf
brew install --cask font-hack-nerd-font
```

### Install Antidote

Install Antidote from the Git repository using a shallow clone. This works on
Linux and macOS and keeps the loader and plugin clones in a stable user
directory:

```sh
mkdir -p "$HOME/.local/share/zsh"
git clone --depth=1 https://github.com/mattmc3/antidote.git \
  "$HOME/.local/share/zsh/antidote"
```

> [!NOTE]
> On macOS, avoid installing Antidote with Homebrew. Homebrew upgrades can
> replace the Cellar path and invalidate the plugin installation. Use the Git
> installation above instead.

Use [Antidote](https://antidote.sh/) to manage the Zsh plugins.

Review the loaded plugins in [`.config/zsh/.zsh_plugins.txt`](.config/zsh/.zsh_plugins.txt):

- [`zsh-users/zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) displays suggestions from your command history as you type.
- [`zsh-users/zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) highlights valid and invalid shell syntax before a command runs.
- [`zsh-users/zsh-history-substring-search`](https://github.com/zsh-users/zsh-history-substring-search) searches command history using the text currently entered at the prompt.
- [`zsh-users/zsh-completions`](https://github.com/zsh-users/zsh-completions) provides additional completion definitions for Zsh commands.
- [`ohmyzsh/ohmyzsh`](https://github.com/ohmyzsh/ohmyzsh) provides the `git` and `alias-finder` plugins.

The tracked manifest contains the shared plugin baseline. Add machine-specific plugins to `.config/zsh/.zsh_plugins.local.txt` with:

```zsh
zsh-plugin-install ohmyzsh/ohmyzsh
```

This keeps local additions separate from the shared `.zsh_plugins.txt` manifest. The direct Antidote equivalent is `antidote install <plugin> "$ZDOTDIR/.zsh_plugins.local.txt"`.

Antidote reads the manifest and generates a cached plugin bundle. Update the installed plugins and regenerate the bundle with:

```zsh
zsh-plugins-update
```

### Install Starship

Install [Starship](https://starship.rs/) separately because package availability
varies by distribution.

#### Fedora

Enable the Starship COPR and install Starship with DNF:

```sh
sudo dnf copr enable -y atim/starship
sudo dnf install -y starship
```

#### Debian and Ubuntu

Install Starship with APT:

```sh
sudo apt install -y starship
```

#### Linux Mint

Install Starship with the official installer:

```sh
curl -sS https://starship.rs/install.sh | sh
```

#### macOS

Install Starship with Homebrew:

```sh
brew install starship
```

### Install Nerd Font

Install Nerd Font to provide the icons and glyphs used by the Starship prompt. This configuration uses [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts), but you can choose another available Nerd Font such as JetBrainsMono Nerd Font.

Install Hack Nerd Font for the current user using the instructions for your platform:

#### Fedora

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f
```

Select `Hack Nerd Font` in your terminal emulator. To use another font, replace `Hack.tar.xz` with the matching archive from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

#### Debian, Ubuntu, and Linux Mint

Install Fontconfig first so the `fc-cache` command is available:

```sh
sudo apt install -y fontconfig
```

```sh
mkdir -p "$HOME/.local/share/fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz \
  | tar -xJ -C "$HOME/.local/share/fonts"
fc-cache -f -v "$HOME/.local/share/fonts"
```

If `fc-cache` is still unavailable after installing `fontconfig`, open a new shell or run `hash -r` to refresh the shell's command lookup. Verify the installation with `fc-list | grep -i 'Hack Nerd Font'`.

Select `Hack Nerd Font` in your terminal emulator. To use another font, replace `Hack.tar.xz` with the matching archive from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

#### macOS

On macOS, install Hack Nerd Font with Homebrew's font casks:

```sh
brew install --cask font-hack-nerd-font
```

### Install Podman/Docker

Install a container engine before using the Docker-compatible aliases in the Zsh configuration.

#### Fedora

Use [Podman](https://podman.io/) as the Fedora container engine. Install Podman and Podman Compose if they are not already installed:

```sh
sudo dnf install -y podman podman-compose
```

Use [Podman Compose](https://github.com/containers/podman-compose) for Compose-compatible commands. The Podman module maps `docker` to `podman` and `docker-compose` to `podman-compose`.

#### Debian, Ubuntu, and Linux Mint

On Debian, Ubuntu, and Linux Mint, configure Docker's official APT repository by following the distribution-specific instructions in the [Docker Engine installation guide](https://docs.docker.com/engine/install/). Then install Docker Engine and the Docker Compose plugin:

```sh
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo docker run hello-world
docker compose version
```

Use the `docker-compose-plugin` package for the `docker compose` command. Avoid the legacy standalone `docker-compose` package.

#### macOS

On macOS, choose [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Colima](https://github.com/abiosoft/colima).

With Docker Desktop, use the bundled `docker` and `docker-compose` commands and enable the Docker CLI in its settings. The Podman module does not override these commands unless both `podman` and `podman-compose` are installed.

With Colima, install the Docker CLI, the standalone Compose binary, and Colima, then start the virtual machine:

```sh
brew install docker docker-compose colima
colima start
```

Homebrew installs the standalone `docker-compose` binary outside the Docker CLI plugin path. Link it into the CLI plugin directory so `docker compose` works:

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

After the first checkout, load the Zsh configuration to enable the `dotfiles` helper:

```sh
source "$HOME/.config/zsh/.zshrc"
```

Alternatively, start a new Zsh session.

The checkout places tracked files directly in your home directory. Use the normal paths for files such as `AGENTS.md`, `.config/zsh`, and `.config/tmux`; Git stores the bare repository separately at `~/.dotfiles`.

### Manage the dotfiles repository

Use the `dotfiles` helper to manage the bare repository. It uses `~/.dotfiles` as the Git directory and `$HOME` as the working tree:

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

Run `dotfiles update` to pull the latest upstream changes with fast-forward-only behavior. The helper resets files whose local content already matches upstream; it keeps and lists genuine local edits that would be overwritten.

Run `dotfiles update-force` to reset every tracked file in `$HOME` to the repository state. The command asks for confirmation; pass `-y` to skip it (`dotfiles update-force -y`). Use it when the work tree has drifted and a normal update refuses to proceed. Skip-worktree files remain untouched.

Run `dotfiles reload` to reload `.zshenv` and `.zshrc` in the current Zsh shell after configuration changes.

Run these commands from `$HOME` when using relative paths. The Zsh configuration loads the helper from [`$HOME/.config/zsh/aliases.zsh`](.config/zsh/aliases.zsh).

## AI agent configuration

Read the shared AI-agent guidelines in [`~/AGENTS.md`](AGENTS.md). This file contains the common rules for all AI agents in this configuration.

Use these agent-specific files to load the shared guidelines:

- `$HOME/.codex/AGENTS.md` references `~/AGENTS.md` for Codex.
- `$HOME/.copilot/copilot-instructions.md` references `~/AGENTS.md` for GitHub Copilot.
- `$HOME/.claude/CLAUDE.md` imports `~/AGENTS.md` for Claude Code.
- `$HOME/.gemini/GEMINI.md` imports `~/AGENTS.md` for Gemini CLI and Google Antigravity.
- `$HOME/.config/opencode/opencode.json` loads `~/AGENTS.md` for OpenCode.
- `$HOME/.cursor/rules/ai-guidelines.mdc` references `~/AGENTS.md` for Cursor.
- `$HOME/.agents/rules/ai-guidelines.md` references `~/AGENTS.md` for Google Antigravity workspace rules.

Keep agent-specific configuration small by using [`~/AGENTS.md`](AGENTS.md) as the single source of truth. Store application and shell configuration under `.config`; keep shared AI-agent guidance in the root-level `AGENTS.md`.

## Component documentation

Read the focused README for each major configuration:

- [Zsh configuration](.config/zsh/README.md)
- [Starship prompt](.config/starship/README.md)
- [Tmux configuration](.config/tmux/README.md)

## Credits

See [Radley Lewis's dotfiles](https://github.com/radleylewis/dotfiles) for the original inspiration.

## License

Use this project under the MIT License. Read [LICENSE](LICENSE) for details.
