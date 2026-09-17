# nixos config

Flake for `konkuter` (desktop) and `nixos`/`default` (laptop)/or other pcs without big screen.

Most home-manager stuff is just symlinked files, basically working like GNU
stow. A few exceptions, like tmux, are done the home-manager way to avoid
manually sourcing and installing plugins. Neovim isn't managed by Nix at all -
simpler that way, and lazy.nvim makes its own lock files anyway.

Steam launch options:

```
/run/current-system/sw/bin/hypr-gaming gamemoderun mangohud %command%
```

```
/run/current-system/sw/bin/hypr-gaming --res 3840x1600@59.96 gamemoderun mangohud %command%
```

## TODO

- some libraries still hang off nix-ld for python packages (make a per-project flake instead)
- new window/browser tab on another workspace should follow you there, currently doesn't
- luks password screen is still ugly
- bare terminal + hyprland flash briefly on login
- same flash on shutdown
- file picker from browser to big
- [gaming mode] set noctalia bar to autohide on workspace 10
- add an nh autoclean service
