# ~/.config/zsh/modules/podman.zsh

# Set aliases for Docker commands to use Podman when both tools are installed.
if command -v podman >/dev/null 2>&1 && command -v podman-compose >/dev/null 2>&1; then
  export PODMAN_COMPOSE_WARNING_LOGS=false
  alias docker='podman'
  alias docker-compose='podman-compose'
fi
