# Dotfiles

Personal dotfiles repository managed with GNU Stow and a small Go CLI.

## Quick start

Run the installer from the repo root:

```sh
./setup_dotfiles_cli.sh
```

This will:
- install `stow` if missing (macOS or Linux)
- stow the folders listed in `STOW_FOLDERS` (default: `nvim,tmux,zsh`)
- add the alias `sd` to `~/.zshrc` for easy re-runs

Reload your shell or source the file:

```sh
source ~/.zshrc
```

Then you can run:

```sh
sd
```

## CLI usage

The CLI is available via the `dotman` wrapper:

```sh
./dotman <command>
```

Commands:
- `install` - install packages and stow dotfiles
- `update` - pull and restow
- `sync` - restow only
- `sync-home` - sync local configs into this repo (prompts on conflicts)
- `push` - commit and push changes
- `edit` - pick a dotfile to edit

Examples:

```sh
./dotman sync-home
./dotman push -m "sync home configs"
```

## Environment variables

- `DOTFILES`: path to the dotfiles repo (defaults to script directory)
- `STOW_FOLDERS`: comma-separated list of stow packages

Example:

```sh
STOW_FOLDERS="nvim,tmux" ./setup_dotfiles_cli.sh
```
