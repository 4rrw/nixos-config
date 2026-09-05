if status is-interactive
    starship init fish | source
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

set PATH $PATH /home/stshalson/.local/bin

# nvim installed via bob
fish_add_path ~/.local/share/bob/nvim-bin

alias vim "nvim"
alias ls "eza"
alias cd "zoxide"
# set PATH "$PATH":"$HOME/.local/scripts/"

# bitwarden ssh agent
set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
# Run when changing directory
function cd
    builtin cd $argv
    auto_venv
end

# Run at shell startup (will work in tmux sessions)
if set -q TMUX
    auto_venv
end

#if status is-interactive
# and not set -q TMUX
#    exec tmux
# end
