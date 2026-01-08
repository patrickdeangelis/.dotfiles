#!/usr/bin/env zsh

if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="nvim,tmux,zsh"
fi

if [[ -z $DOTFILES ]]; then
    SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
    DOTFILES=$SCRIPT_DIR
fi

export STOW_FOLDERS DOTFILES
# $DOTFILES/install

# I am using zsh instead of bash.  I was having some troubles using bash with
# arrays.  Didn't want to investigate, so I just did zsh

ensure_stow() {
    if command -v stow >/dev/null 2>&1; then
        return 0
    fi

    if command -v brew >/dev/null 2>&1; then
        brew install stow
        return $?
    fi

    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y stow
        return $?
    fi

    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y stow
        return $?
    fi

    if command -v yum >/dev/null 2>&1; then
        sudo yum install -y stow
        return $?
    fi

    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm stow
        return $?
    fi

    echo "stow not found and no supported package manager detected."
    return 1
}

if ! ensure_stow; then
    exit 1
fi

ZSHRC="$HOME/.zshrc"
ALIAS_LINE="alias sd=\"$DOTFILES/setup_dotfiles_cli.sh\""
if [[ -f "$ZSHRC" ]]; then
    if ! grep -q "^alias sd=" "$ZSHRC"; then
        echo "$ALIAS_LINE" >> "$ZSHRC"
        echo "Added alias to $ZSHRC: sd"
    fi
else
    echo "$ALIAS_LINE" > "$ZSHRC"
    echo "Created $ZSHRC and added alias: sd"
fi

pushd "$DOTFILES"
for folder in $(echo "$STOW_FOLDERS" | sed "s/,/ /g")
do
    stow -D "$folder"
    stow "$folder"
done
popd
