# The desktop. Shared config is in modules/nixos/common.nix.
#   sudo nixos-rebuild switch --flake ~/.config/nixos#konkuter

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The hypr lua files branch on this via /etc/hostname, so renaming it changes
  # the monitor, gaps and layout setup.
  networking.hostName = "konkuter";

  home-manager.users."stshalson" = import ./home.nix;

  # The release this machine was installed with, not something to keep updated --
  # it pins state-format compatibility.
  system.stateVersion = "26.05";
}
