# ~/.config/zsh/modules/podman.zsh

# Disable Podman Compose warning logs
export PODMAN_COMPOSE_WARNING_LOGS=false

# Set alias for Docker commands to use Podman instead
alias docker='podman'
alias docker-compose='podman-compose'
