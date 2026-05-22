# ============================================================
# FASTFETCH
# ============================================================
alias fastfetch="pokeget random --hide-name | fastfetch"

fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# HISTÓRICO
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1100000000
SAVEHIST=1000000000

setopt auto_cd                  # cd sem precisar digitar 'cd'
setopt hist_expire_dups_first   # expira duplicatas primeiro
setopt hist_find_no_dups        # não encontrar duplicatas
setopt hist_ignore_dups         # não salvar duplicatas
setopt interactivecomments      # liga comentários no terminal
setopt share_history            # compartilha o histórico entre sessões

# ============================================================
# PATH
# ============================================================
typeset -U path PATH

path=(
  /opt/homebrew/bin
  /opt/homebrew/share/google-cloud-sdk/bin
  "$HOME/.bun/bin"
  $path
)

export PATH
export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"

# ============================================================
# COMPLETIONS
# ============================================================
autoload -U compinit; compinit

# ============================================================
# MISE
# ============================================================
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# ============================================================
# ALIASES & FUNÇÕES
# ============================================================
# Brew
bu() {
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
  alias ls='eza --icons=always --long --git --no-filesize --no-time --no-user --no-permissions'
  alias la='eza --icons=always --long --git --no-user --no-permissions --all'
  alias lt='eza --tree --level=2 --icons=always'
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
# UV
# ============================================================
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

# ============================================================
# ZOXIDE
# ============================================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# ============================================================
# BUN COMPLETIONS
# ============================================================
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ============================================================
# ALIASES EXTRAS
# ============================================================
alias claude-mem='$HOME/.bun/bin/bun "$HOME/.claude/plugins/cache/thedotmack/claude-mem/12.1.0/scripts/worker-service.cjs"'

# ============================================================
# POWERLEVEL10K
# ============================================================
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
