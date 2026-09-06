# System configuration shared by every host.
#
# Anything that depends on the specific machine -- disks, bootloader, hostname,
# stateVersion, hardware quirks -- belongs in hosts/<name>/configuration.nix
# instead. Everything here is meant to be identical everywhere.

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
    # Without this a single pre-existing file aborts the ENTIRE activation --
    backupFileExtension = "hm-bak";
    # home-manager.users.<name> is set per host, so a host can point at its own
    # home.nix.
  };

  # use experimental features - nix-command and flakes
  # add noctalia cachix
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

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # enable fish shell module
  programs.fish.enable = true;

  # provides the standard dynamic linker path so prebuilt dynamically-linked
  # binaries (e.g. nvim-treesitter's tree-sitter CLI/parsers) can run
  programs.nix-ld.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  main-user.enable = true;
  main-user.userName = "stshalson";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
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
    alsa-utils # amixer/alsamixer/speaker-test - needed to debug audio routing
    #
    spotify
  ];

  # hyprland module
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # noctalia
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # noctalia greeter
  programs.noctalia-greeter.enable = true;

  # WirePlumber remembers which device each stream was last on and pins it
  # there, so changing the default output (in noctalia, pavucontrol, wpctl --
  # anything) leaves already-playing audio on the old device. Turning the
  # restore off makes streams follow the default instead, which is what makes
  # an output switcher behave the way you expect.
  services.pipewire.wireplumber.extraConfig."51-follow-default-sink" = {
    "wireplumber.settings" = {
      "node.stream.restore-target" = false;
    };
  };

  # List services that you want to enable:

  # Open SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Enable bitwarden SSH Agent
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.bitwarden-ssh-agent.sock
  '';
}
