# ============================================================
# STARTUP BANNER / FASTFETCH
# ============================================================
alias fastfetch='pokeget random --hide-name | command fastfetch'

if [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Orca" ]]; then
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
  /opt/homebrew/opt/libpq/bin
  /opt/homebrew/share/google-cloud-sdk/bin
  "$HOME/.bun/bin"
  "$HOME/.local/bin"
  $path
)

export PATH
export BUN_INSTALL="$HOME/.bun"
export EDITOR="nvim"
# Segredos (tokens) carregados de arquivo separado com permissao 600
[ -f "$HOME/.config/secrets/tokens.env" ] && source "$HOME/.config/secrets/tokens.env"

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
if command -v zoxide >/dev/null 2>&1 && [ -z "$DISABLE_ZOXIDE" ]; then
  eval "$(zoxide init zsh --cmd cd)"
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
gcn() { git commit --no-verify -m "$1"; }
# Funcoes de trabalho (CEMIG/GCP) fora do repo de dotfiles
[ -f "$HOME/.config/zsh/cemig.zsh" ] && source "$HOME/.config/zsh/cemig.zsh"

# ============================================================
# POWERLEVEL10K THEME
# ============================================================
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/josericardo/.bun/_bun" ] && source "/Users/josericardo/.bun/_bun"
