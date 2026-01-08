# Dotfiles

Personal dotfiles repository managed with GNU Stow and a small Go CLI.

## Quick start

Run the installer from the repo root:

```sh
./dotman/install_dotman.sh
```

This will:
- install Go if missing (macOS or Linux)
- make the `dotman` wrapper executable
- add the alias `dotman` to `~/.zshrc`

Reload your shell or source the file:

```sh
source ~/.zshrc
```

Then you can run:

```sh
dotman
```

## CLI usage

The CLI is available via the wrapper in `dotman/`:

```sh
./dotman/dotman <command>
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
./dotman/dotman sync-home
./dotman/dotman push -m "sync home configs"
```

## Environment variables

- `DOTFILES`: path to the dotfiles repo (defaults to script directory)

## Layout

- `dotman/` contains the CLI source
- `dotfiles/` contains stow packages and config files
- `dotfiles/mapping.yml` documents where each package maps in the OS

## Tests

Unit tests:

```sh
cd dotman
go test ./...
```

E2E (Docker):

```sh
./dotman/e2e/run.sh
```
