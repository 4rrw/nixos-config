# The laptop. Shared config is in modules/nixos/common.nix.
#   sudo nixos-rebuild switch --flake ~/.config/nixos#nixos

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  home-manager.users."stshalson" = import ./home.nix;

  # In UCM split mode the headphones stay silent on jack insert; forcing ACP
  # gives one sink that switches ports properly. device.name is this machine's
  # PCI path, hence not in common.nix.
  services.pipewire.wireplumber.extraConfig."52-hda-use-acp" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"; } ];
        actions.update-props = {
          "api.alsa.use-acp" = true;
          "api.alsa.split-enable" = false;
        };
      }
    ];
  };

  system.stateVersion = "26.05";
}
