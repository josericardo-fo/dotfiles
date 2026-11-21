# dotfiles

macOS config (zsh + oh-my-zsh + powerlevel10k, Ghostty, git, fastfetch), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

On a fresh Mac, with [Homebrew](https://brew.sh) installed:

```sh
# Rust first: the Brewfile installs a cargo crate (pokeget); .zshenv already sources ~/.cargo/env
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
. "$HOME/.cargo/env"

git clone git@github.com:josericardo-fo/dotfiles.git ~/Developer/Projects/dotfiles
cd ~/Developer/Projects/dotfiles
brew bundle --file=.config/Brewfile

# oh-my-zsh and its custom plugins, cloned directly (the installer would rewrite ~/.zshrc)
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
P=~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "$P/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$P/zsh-syntax-highlighting"
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$P/you-should-use"

# Bun (before stow, so its installer finds no ~/.zshrc to edit; .zshrc already sets it up)
curl -fsSL https://bun.sh/install | bash

stow --no-folding -t ~ .
```

Existing files in `~` conflict with stow; use `stow --adopt --no-folding -t ~ .` to move them into the repo (then review with `git diff`).

## Adding a file

Move it into the repo at the same path relative to `~`, then run `stow --no-folding -t ~ .` again.

## Not versioned

Secrets and work-specific config live outside the repo and are sourced if present:

- `~/.config/secrets/tokens.env`
- `~/.config/zsh/work.zsh`

## Claude Code (`.claude/`)

Versioned: `CLAUDE.md`, `model-routing.md`, `agents/`, `settings.json`, `keybindings.json` and my own generic skills (`skills/bitwarden`). Stow links them file by file into `~/.claude`, so runtime state (`projects/`, memory, history, credentials, plugin cache) stays out of the repo.

Orca writes its hooks and status line into `settings.json`. A git clean filter (`.gitattributes` + `[filter "strip-orca"]` in `.gitconfig`, script in `.config/git/filters/strip-orca.jq`) strips them, so only my own settings are versioned; Orca re-adds them on startup. Two consequences:

- `git checkout`/`git restore`/`git stash` of `settings.json` writes the stripped version, removing the Orca hooks until Orca restarts.
- The filter is defined in the stowed `~/.gitconfig` and runs `jq` (ships with macOS). If `jq` is missing, git refuses to stage `settings.json`; before stowing, the filter is undefined and git would stage the hooks as-is.

Third-party skills are not copied; reinstall them with the [`skills`](https://github.com/vercel-labs/skills) CLI:

```sh
npx skills add mattpocock/skills -g -a claude-code -y \
  -s code-review codebase-design improve-codebase-architecture grilling tdd writing-for-agents handoff
npx skills add vercel-labs/agent-browser -g -a claude-code -y -s agent-browser
npx skills add microsoft/playwright-cli -g -a claude-code -y -s playwright-cli
npx skills add stablyai/orca -g -a claude-code -y -s computer-use orca-cli orchestration
claude plugin install frontend-design@claude-plugins-official
```
