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
- `~/.config/zsh/cemig.zsh`
