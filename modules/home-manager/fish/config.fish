set -g fish_greeting

# -g, not the universal scope fish_add_path defaults to: universal variables
# live in fish_variables, which this module deliberately does not manage.
fish_add_path -g $HOME/.local/bin

alias vim "nvim"
alias ls "eza"

if status is-interactive
    starship init fish | source

    # Makes `cd` zoxide's smart jump -- it still behaves like plain cd for real
    # paths -- and adds `cdi` for the interactive picker.
    zoxide init fish --cmd cd | source

    # Activate a project's .venv on directory change. A PWD handler rather than
    # a `cd` wrapper, so it also fires for zoxide jumps, prevd/nextd, and any
    # other way the directory moves. The bare call covers shell startup, which
    # is not a change: new tmux panes and terminals begin inside the project.
    function __auto_venv --on-variable PWD
        auto_venv
    end
    auto_venv
end
