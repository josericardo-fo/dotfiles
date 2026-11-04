# dotfiles

macOS config (zsh + oh-my-zsh + powerlevel10k, Ghostty, git, fastfetch), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```sh
git clone git@github.com:josericardo-fo/dotfiles.git ~/Developer/Projects/dotfiles
cd ~/Developer/Projects/dotfiles
brew bundle --file=.config/Brewfile
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

Not versioned here:

- The Orca hooks and status line in `settings.json` are written by Orca and do nothing when Orca is absent.

Third-party skills are not copied; reinstall them with the [`skills`](https://github.com/vercel-labs/skills) CLI:

```sh
npx skills add mattpocock/skills -g -a claude-code -y \
  -s code-review codebase-design improve-codebase-architecture grilling diagnosing-bugs tdd writing-for-agents handoff
npx skills add vercel-labs/agent-browser -g -a claude-code -y -s agent-browser
npx skills add microsoft/playwright-cli -g -a claude-code -y -s playwright-cli
npx skills add stablyai/orca -g -a claude-code -y -s computer-use orca-cli orchestration
claude plugin install frontend-design@claude-plugins-official
```
