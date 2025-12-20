# ============================================================
# HISTÓRICO (melhorado + compartilhado entre sessões)
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY         # não sobrescreve histórico
setopt INC_APPEND_HISTORY     # salva conforme executa
setopt SHARE_HISTORY          # compartilha entre abas/janelas
setopt HIST_IGNORE_ALL_DUPS   # remove duplicatas
setopt HIST_EXPIRE_DUPS_FIRST # expira duplicatas primeiro
setopt HIST_REDUCE_BLANKS     # remove espaços extras
setopt HIST_VERIFY            # confirma expansões antes de executar

# ============================================================
# PATH
# ============================================================
typeset -U path PATH

path=(
  /opt/homebrew/bin
  /opt/homebrew/share/google-cloud-sdk/bin
  $path
)

export PATH

# ============================================================
# PYENV
# ============================================================
export PYENV_ROOT="$HOME/.pyenv"

if [[ -d "$PYENV_ROOT/bin" ]]; then
  path=("$PYENV_ROOT/bin" $path)
fi

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi

# ============================================================
# ALIASES & FUNÇÕES
# ============================================================

# Brew
brewup() {
  command -v brew >/dev/null 2>&1 || { echo "brew não encontrado"; return 127; }
  brew update && brew upgrade && brew cleanup && echo "Brew packages updated!"
}

# Docker
alias d='docker'
alias dps='docker ps'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcub='docker compose up --build'
alias dcubd='docker compose up --build -d'

# eza as ls
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --color=always --icons=always --long --git --no-filesize --no-time --no-user --no-permissions"
fi

# ============================================================
# CEMIG / GCLOUD
# ============================================================
alias clogin='gcloud auth application-default login'

ccreds() {
  local src="$HOME/.config/gcloud/application_default_credentials.json"
  local dst="$HOME/Developer/Repos/CEMIG/backend-cemig/service-account.json"

  if [[ ! -f "$src" ]]; then
    echo "Credencial não encontrada em: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dst")"
  cp -f "$src" "$dst"
  echo "Copiado para: $dst"
}

ctunnel() { # Opens a tunnel to the bastion VM for database access
  command -v gcloud >/dev/null 2>&1 || { echo "gcloud não encontrado"; return 127; }

  local RPORT="${1:-5433}"  # remote port on the VM/bastion
  local LPORT="5435"

  echo "Opening tunnel: remote:$RPORT -> local:$LPORT"
  gcloud compute start-iap-tunnel application-bastion-vm "$RPORT" \
    --local-host-port="localhost:$LPORT" \
    --zone="us-central1-a" \
    --project="ufg-prd-energygpt"
}

# ============================================================
# STARSHIP
# ============================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ============================================================
# ZOXIDE
# ============================================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi
