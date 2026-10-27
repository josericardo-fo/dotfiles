# ============================================================
# STARTUP BANNER / FASTFETCH
# ============================================================
# Fica antes do instant prompt do p10k para não gerar aviso de output
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
# PATH
# ============================================================
typeset -U path PATH fpath

path=(
  /opt/homebrew/bin
  /opt/homebrew/opt/libpq/bin
  /opt/homebrew/share/google-cloud-sdk/bin
  "$HOME/.bun/bin"
  "$HOME/.local/bin"
  $path
)

# Completions do Homebrew (gh, eza, bw, uv, mise...) antes do compinit do OMZ
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

export PATH
export BUN_INSTALL="$HOME/.bun"
export EDITOR="vim"
# Segredos (tokens) carregados de arquivo separado com permissao 600
[ -f "$HOME/.config/secrets/tokens.env" ] && source "$HOME/.config/secrets/tokens.env"

# ============================================================
# OH MY ZSH (já roda o compinit)
# ============================================================
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

# zsh-syntax-highlighting deve ser o último plugin
plugins=(zsh-autosuggestions you-should-use zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# ============================================================
# HISTÓRICO
# ============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# Demais opções (share_history, hist_ignore_space, auto_cd...) já vêm do OMZ
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks

# ============================================================
# TOOLS
# ============================================================

# Mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1 && [ -z "$DISABLE_ZOXIDE" ]; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# fzf: Ctrl-R (histórico), Ctrl-T (arquivos), Alt-C (pastas)
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  # fd respeita .gitignore e é mais rápido que find; bat dá preview com cor
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
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
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
