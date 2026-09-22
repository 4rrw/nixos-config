# hacky script to open files from lazygit using "e"(edit) in currently
# opened neovim instance in the same tab
#
# Usage: lazygit-nvim-edit <file> [line]

target=$1
line=${2:-}

# Not launched from inside neovim: just edit normally
if [ -z "${NVIM:-}" ]; then
    if [ -n "$line" ]; then
        exec nvim "+$line" -- "$target"
    fi
    exec nvim -- "$target"
fi

# sends bindings to neovim to exit lazygit and got the file:line
nvim --server "$NVIM" --remote-send 'q<C-\><C-n><C-w>p'
nvim --server "$NVIM" --remote "$target"
if [ -n "$line" ]; then
    nvim --server "$NVIM" --remote-send ":$line<CR>"
fi

exit 0
