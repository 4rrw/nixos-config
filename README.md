# nixos config

Flake for `konkuter` (desktop) and `nixos`/`default` (laptop)/or other pcs without big screen.

Most home-manager stuff is just symlinked files, basically working like GNU
stow. A few exceptions, like tmux, are done the home-manager way to avoid
manually sourcing and installing plugins. Neovim isn't managed by Nix at all -
simpler that way, and lazy.nvim makes its own lock files anyway.

XWayland apps aren't scaled explicitly.

For now, start games in Steam with:

```
gamescope -W 3840 -H 1645 -b -r 120 --mangoapp -- gamemoderun %command%
```

## TODO

- some libraries still hang off nix-ld for python packages (make a per-project flake instead)
- new window/browser tab on another workspace should follow you there, currently doesn't
- luks password screen is still ugly
- bare terminal + hyprland flash briefly on login
- same flash on shutdown
- bitwarden autostart is wonky, won't close after entering the password
- [gaming mode] set noctalia bar to autohide on workspace 10
- add an nh autoclean service
