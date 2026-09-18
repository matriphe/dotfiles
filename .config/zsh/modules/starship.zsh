# ~/.config/zsh/modules/starship.zsh

# Tell Starship where to find its configuration.
export STARSHIP_CONFIG="$ZDOTDIR/starship/starship.toml"

# Initialize Starship prompt for Zsh
eval "$(starship init zsh)"
