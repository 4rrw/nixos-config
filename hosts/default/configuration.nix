# Host: the laptop. `sudo nixos-rebuild switch --flake ~/.config/nixos#nixos`
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

  networking.hostName = "nixos";

  home-manager.users."stshalson" = import ./home.nix;

  # The onboard HDA codec comes up in UCM "split" mode, where WirePlumber
  # exposes Speaker and Headphones as separate sinks and only ever creates one
  # of them. On jack insert the driver enables the headphone pin but nothing
  # runs the UCM unmute sequence, so the headphones stay silent. Forcing ACP
  # gives a single Analog Stereo sink with automatic port switching instead.
  #
  # device.name is this machine's PCI path, which is why this cannot live in
  # common.nix.
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
