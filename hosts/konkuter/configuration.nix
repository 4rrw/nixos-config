# Host: the desktop. `sudo nixos-rebuild switch --flake ~/.config/nixos#konkuter`
#
# Only what is specific to THIS machine lives here. Everything shared with the
# other hosts is in modules/nixos/common.nix.

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The hypr lua files branch on /etc/hostname, so this name is what selects
  # the LG C2 monitor block, the OLED burn-in gap randomizer and the centered
  # master layout. Changing it changes the desktop layout.
  networking.hostName = "konkuter";

  home-manager.users."stshalson" = import ./home.nix;

  # Set this to the NixOS release this machine was INSTALLED with -- read it off
  # the /etc/nixos/configuration.nix the installer generated. It is not a
  # version to keep up to date; it pins state-format compatibility.
  system.stateVersion = "26.05";
}
