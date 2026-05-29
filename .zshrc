# ============================================================
# STARTUP BANNER / FASTFETCH
# ============================================================
alias fastfetch='pokeget random --hide-name | command fastfetch'

if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  sleep 0.05 && fastfetch
fi

# ============================================================
# POWERLEVEL10K INSTANT PROMPT
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# OH MY ZSH
# ============================================================
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(zsh-autosuggestions zsh-syntax-highlighting you-should-use)

source "$ZSH/oh-my-zsh.sh"

# ============================================================
# HISTÓRICO
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1100000000
SAVEHIST=1000000000

setopt auto_cd
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt interactivecomments
setopt share_history

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
autoload -U compinit
compinit

# ============================================================
# TOOLS
# ============================================================

# Mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# UV
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ============================================================
# ALIASES & FUNÇÕES
# ============================================================

# Brew
bu() {
  command -v brew >/dev/null 2>&1 || { echo "brew não encontrado"; return 127; }
  brew update && brew upgrade && brew cleanup && echo "Brew updated and cleaned up!"
}

# Claude Mem
alias claude-mem='$HOME/.bun/bin/bun "$HOME/.claude/plugins/cache/thedotmack/claude-mem/12.1.0/scripts/worker-service.cjs"'

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

# Git
gcn() { git commit --no-verify -m "$*"; }

# ============================================================
# CEMIG / GCLOUD
# ============================================================
_open_cemig_tunnel() {
  command -v cloud-sql-proxy >/dev/null 2>&1 || { echo "cloud-sql-proxy não encontrado. Instale com: brew install cloud-sql-proxy"; return 127; }

  local lport="${1:-5435}"
  local instance="ufg-prd-energygpt:us-central1:application-bastion-vm"
  local creds="$HOME/Developer/Repos/CEMIG/monorepo/apps/backend/service-account.json"

  echo "Opening tunnel: Cloud SQL $instance -> local:$lport"
  cloud-sql-proxy "$instance" \
    --port="$lport" \
    --credentials-file="$creds"
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
# POWERLEVEL10K THEME
# ============================================================
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
