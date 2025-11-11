export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# ----------------------
# Pyenv
# ----------------------
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# ----------------------
# Aliases
# ----------------------

# Docker
alias d='docker'
alias dps='docker ps'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcub='docker compose up --build'
alias dcubd='docker compose up --build -d'

# eza as ls
alias ls="eza --color=always --icons=always --long --git --no-filesize --no-time --no-user --no-permissions"

# CEMIG
alias clogin='gcloud auth application-default login'
alias ccreds='cat "$HOME/.config/gcloud/application_default_credentials.json" > "$HOME/Developer/Repos/CEMIG/backend-cemig/service-account.json"'

ctunnel() { # Opens a tunnel to the bastion VM for database access
  local RPORT="${1:-5433}" # remote port on the VM/bastion

  echo "Opening tunnel: remote:$RPORT -> local:5435"
  gcloud compute start-iap-tunnel application-bastion-vm "$RPORT" \
    --local-host-port=localhost:5435 \
    --zone=us-central1-a \
    --project=ufg-prd-energygpt
}

# ----------------------
# Starship
# ----------------------
eval "$(starship init zsh)"

# ----------------------
# Zoxide
# ----------------------
eval "$(zoxide init --cmd cd zsh)"
