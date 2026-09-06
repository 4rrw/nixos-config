set -g fish_greeting

# -g, not the universal scope fish_add_path defaults to; fish_variables is
# deliberately unmanaged.
fish_add_path -g $HOME/.local/bin

alias vim "nvim"
alias ls "eza"

if status is-interactive
    starship init fish | source

    # Makes `cd` zoxide's smart jump; plain cd still works, and `cdi` picks
    # interactively.
    zoxide init fish --cmd cd | source

    # Activate a project's .venv on cd. A PWD handler, not a `cd` wrapper, so it
    # fires for zoxide jumps and prevd/nextd too; the bare call covers startup.
    function __auto_venv --on-variable PWD
        auto_venv
    end
    auto_venv
end
