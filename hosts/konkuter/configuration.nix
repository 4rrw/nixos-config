# The desktop. Shared config is in modules/nixos/common.nix.
#   sudo nixos-rebuild switch --flake ~/.config/nixos#konkuter

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The ntfs driver below needs kernel 7.1 or newer
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # The hypr lua files branch on this, so renaming changes monitors, gaps and layout.
  networking.hostName = "konkuter";

  home-manager.users."stshalson" = import ./home.nix;

  # Under /media so nautilus lists it; mounts under /mnt are never shown.
  fileSystems."/media/BX500" = {
    device = "/dev/disk/by-uuid/80226D53226D4EEA";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "umask=022"
      "noatime"
      "windows_names"
      "nofail"
    ];
  };

  # Refuses to mount read-write if windows was left hibernated by fast startup.
  fileSystems."/media/Windows" = {
    device = "/dev/disk/by-uuid/5CB67FEDB67FC5D4";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "umask=022"
      "noatime"
      "windows_names"
      "nofail"
    ];
  };

  # Pins state-format compatibility; not a version to keep updated.
  system.stateVersion = "26.05";
}
