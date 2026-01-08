#!/usr/bin/env bash
set -euo pipefail

ROOT="/repo"
export HOME="/tmp/home"

INSTALL_ROOT="$ROOT"
SYNC_ROOT="/tmp/dotfiles"
mkdir -p "$SYNC_ROOT/dotfiles"

mkdir -p "$HOME/.config/nvim-lazy/lua"
mkdir -p "$HOME/.tmux/scripts"

cat <<'EOF' > "$HOME/.config/nvim-lazy/init.lua"
print("lazyvim")
EOF

cat <<'EOF' > "$HOME/.tmux.conf"
set -g mouse on
EOF

cat <<'EOF' > "$HOME/.tmux/scripts/tmux_swap_to.sh"
#!/usr/bin/env bash
echo "swap"
EOF
chmod +x "$HOME/.tmux/scripts/tmux_swap_to.sh"

export DOTFILES="$INSTALL_ROOT"
"$ROOT/dotman/install_dotman.sh"

export DOTFILES="$SYNC_ROOT"
"$ROOT/dotman/dotman" sync-home

test -f "$SYNC_ROOT/dotfiles/lazy-vim/init.lua"
test -f "$SYNC_ROOT/dotfiles/tmux/.tmux.conf"
test -f "$SYNC_ROOT/dotfiles/tmux/.tmux/scripts/tmux_swap_to.sh"
test -f "$HOME/.zshrc"

echo "E2E OK"
