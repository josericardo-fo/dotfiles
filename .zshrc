# ============================================================
# HISTÓRICO
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

setopt hist_expire_dups_first  # expira duplicatas primeiro
setopt hist_find_no_dups       # não encontrar duplicatas
setopt hist_ignore_dups        # não salvar duplicatas
setopt share_history           # compartilha o histórico entre sessões
setopt inc_append_history      # salva o histórico imediatamente, não apenas no final da sessão
setopt interactivecomments     # liga comentários no terminal

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
# MISE
# ============================================================
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# ============================================================
# ALIASES & FUNÇÕES
# ============================================================

brewup() {
  command -v brew >/dev/null 2>&1 || { echo "brew não encontrado"; return 127; }
  brew update && brew upgrade && brew cleanup && echo "Brew updated and cleaned up!"
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
_open_cemig_tunnel() {
  command -v gcloud >/dev/null 2>&1 || { echo "gcloud não encontrado"; return 127; }

  local rport="${1:-5433}"
  local lport="${2:-5435}"

  echo "Opening tunnel: remote:$rport -> local:$lport"
  gcloud compute start-iap-tunnel application-bastion-vm "$rport" \
    --local-host-port="localhost:$lport" \
    --zone="us-central1-a" \
    --project="ufg-prd-energygpt"
}

csetup() {
  command -v gcloud >/dev/null 2>&1 || { echo "gcloud não encontrado"; return 127; }

  echo "== gcloud login =="
  gcloud auth application-default login || return 1

  echo "== Copiando credenciais =="
  local src="$HOME/.config/gcloud/application_default_credentials.json"
  local dst="$HOME/Developer/Repos/CEMIG/monorepo/apps/backend/service-account.json"

  [[ -f "$src" ]] || { echo "Credencial não encontrada em: $src"; return 1; }

  mkdir -p "$(dirname "$dst")" || return 1
  cp -f "$src" "$dst" || return 1

  echo "Copiado para: $dst"

  echo "== Abrindo túnel =="
  _open_cemig_tunnel "$1"
}

ctunnel() {
  echo "== Abrindo túnel =="
  _open_cemig_tunnel "$1"
}


# ============================================================
# ZOXIDE
# ============================================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# ============================================================
# STARSHIP
# ============================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
