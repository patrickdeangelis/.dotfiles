#!/usr/bin/env bash

if [[ -z $DOTFILES ]]; then
    SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
    DOTFILES=$(cd -- "$SCRIPT_DIR/.." && pwd)
fi

export DOTFILES

# I am using zsh instead of bash.  I was having some troubles using bash with
# arrays.  Didn't want to investigate, so I just did zsh

step() {
    echo "==> $1"
}

info() {
    echo "    $1"
}

ensure_go() {
    if command -v go >/dev/null 2>&1; then
        info "go already installed"
        return 0
    fi

    step "Installing go"
    if command -v brew >/dev/null 2>&1; then
        brew install go
        return $?
    fi

    if command -v apt-get >/dev/null 2>&1; then
        if command -v sudo >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y golang
        else
            apt-get update
            apt-get install -y golang
        fi
        return $?
    fi

    if command -v dnf >/dev/null 2>&1; then
        if command -v sudo >/dev/null 2>&1; then
            sudo dnf install -y golang
        else
            dnf install -y golang
        fi
        return $?
    fi

    if command -v yum >/dev/null 2>&1; then
        if command -v sudo >/dev/null 2>&1; then
            sudo yum install -y golang
        else
            yum install -y golang
        fi
        return $?
    fi

    if command -v pacman >/dev/null 2>&1; then
        if command -v sudo >/dev/null 2>&1; then
            sudo pacman -S --noconfirm go
        else
            pacman -S --noconfirm go
        fi
        return $?
    fi

    echo "go not found and no supported package manager detected."
    return 1
}

step "Ensuring dependencies"
if ! ensure_go; then
    exit 1
fi

step "Ensuring dotman CLI"
DOTMAN_BIN="$DOTFILES/dotman/dotman"
if [[ ! -x "$DOTMAN_BIN" ]]; then
    chmod +x "$DOTMAN_BIN"
    info "Set executable bit for $DOTMAN_BIN"
else
    info "dotman already executable"
fi

ZSHRC="$HOME/.zshrc"
ALIAS_LINE="alias dotman=\"$DOTMAN_BIN\""
step "Configuring zsh alias"
if [[ -f "$ZSHRC" ]]; then
    if ! grep -q "^alias dotman=" "$ZSHRC"; then
        echo "$ALIAS_LINE" >> "$ZSHRC"
        info "Added alias to $ZSHRC: dotman"
    else
        info "Alias already present in $ZSHRC"
    fi
else
    echo "$ALIAS_LINE" > "$ZSHRC"
    info "Created $ZSHRC and added alias: dotman"
fi
