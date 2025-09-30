export PATH="/opt/homebrew/bin:$PATH"

# ----------------------
# Pyenv
# ----------------------
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

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

# ----------------------
# Starship
# ----------------------
eval "$(starship init zsh)"

# ----------------------
# Zoxide
# ----------------------
eval "$(zoxide init --cmd cd zsh)"