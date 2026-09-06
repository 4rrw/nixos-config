# Shared by every host; anything machine-specific goes in hosts/<name>/configuration.nix.

{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/nixos/main-user.nix
    inputs.home-manager.nixosModules.default
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    # Without this one pre-existing file aborts the whole activation.
    backupFileExtension = "hm-bak";
    # users.<name> is set per host, so each points at its own home.nix.
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMeo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

  programs.fish.enable = true;

  # Gives prebuilt dynamic binaries, like nvim-treesitter's parsers, a linker to find.
  programs.nix-ld.enable = true;

  main-user.enable = true;
  main-user.userName = "stshalson";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    rustc
    cargo
    gcc
    uv
    lua
    nodejs
    #---
    gnumake
    git
    brave
    nemo
    claude-code
    starship
    eza
    fastfetch
    bitwarden-desktop
    btop
    docker
    mpv
    localsend
    flameshot
    tldr
    zoxide
    xournalpp
    p7zip
    unzip
    alsa-utils # for debugging audio routing
    #
    spotify
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  programs.noctalia-greeter.enable = true;

  # WirePlumber otherwise pins each stream to the device it last played on, so
  # switching the default output leaves the audio behind.
  services.pipewire.wireplumber.extraConfig."51-follow-default-sink" = {
    "wireplumber.settings" = {
      "node.stream.restore-target" = false;
    };
  };

  # gvfs gives nemo its Devices and Network tabs, udisks2 lets it mount.
  # No automounter on purpose -- click the disk in nemo, or `udisksctl mount -b`.
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # mDNS, so SMB/NFS hosts turn up in nemo by name. Opens UDP 5353.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Use bitwarden's SSH agent.
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.bitwarden-ssh-agent.sock
  '';
}
