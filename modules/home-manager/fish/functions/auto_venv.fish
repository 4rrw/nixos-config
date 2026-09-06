function auto_venv --description "Activate virtualenv if .venv exists"
    if test -d .venv -a -f .venv/bin/activate.fish
        source .venv/bin/activate.fish
    end
end
