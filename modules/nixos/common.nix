# Shared by every host; anything machine-specific goes in hosts/<name>/configuration.nix.

{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/nixos/main-user.nix
    ../../modules/nixos/nautilus.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/openvpn.nix
    inputs.home-manager.nixosModules.default
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
    inputs.snapmaker-orca.nixosModules.default
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

  main-user.enable = true;
  main-user.userName = "stshalson";

  time.timeZone = "Europe/Warsaw";

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

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

  console.keyMap = "pl2";

  # DOCKER
  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        builder.gc = {
          enabled = true;
          reservedSpace = "120GB";
          maxUsedSpace = "180GB";
          minFreeSpace = "40GB";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Exposes nixpkgs-unstable as `pkgs.unstable`
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev.stdenv.hostPlatform) system;
        config = prev.config;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    # dev stuff
    rustc
    cargo
    gcc
    uv
    lua
    nodejs
    git
    pre-commit
    gnumake
    claude-code
    # larp tools
    fastfetch
    btop
    # actual tools
    ncdu
    lf
    eza
    tldr
    zoxide
    p7zip
    unzip
    sshfs
    syncthing
    losslesscut
    kdePackages.kdenlive
    onlyoffice-desktopeditors
    # network
    networkmanager-openvpn
    # shell
    starship
    xdg-user-dirs # creates and maintains ~/Pictures and friends
    hyprpicker # the SUPER+PRINT colour picker; noctalia has no equivalent
    bibata-cursors # only here because a theme has to be a store path; hypr/looknfeel.lua picks it
    unstable.hyprmod
    # apps
    brave
    bitwarden-desktop
    mpv
    localsend
    xournalpp
    gparted
    spicetify-cli
    spotify
    ncspot
    # other
    ffmpeg-full
    gpu-screen-recorder
    alsa-utils # for debugging audio routing
    # communicators
    vesktop
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs = {
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
    noctalia-greeter.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 6";
      flake = "/home/stshalson/.config/nixos";
    };
    nix-ld = {
      # Gives prebuilt dynamic binaries, like nvim-treesitter's parsers, a linker to find.
      # TODO: use things like this in project flake, not system wide
      enable = true;
      libraries = with pkgs; [
        glib
        libGL
        libice
        libsm
        libx11
        libxext
        libxcb
        icu
      ];
    };
    fish.enable = true;
    snapmaker-orca.enable = true; # NOTE: from custom flake https://github.com/chrstnwhlrt/nix-snapmaker-orca
  };

  services = {
    xserver.xkb = {
      layout = "pl";
      variant = "";
    };
    # WirePlumber otherwise pins each stream to the device it last played on, so
    # switching the default output leaves the audio behind.
    pipewire.wireplumber.extraConfig."51-follow-default-sink" = {
      "wireplumber.settings" = {
        "node.stream.restore-target" = false;
      };
    };
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    fwupd.enable = true;
    # Mounts removable media. No automounter on purpose -- click the disk in the
    # file manager, or `udisksctl mount -b`. gvfs lives in nautilus.nix.
    udisks2.enable = true;
    # mDNS, so SMB/NFS hosts turn up in the file manager by name. Opens UDP 5353.
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };
    syncthing = {
        enable = true;
        group = "users";
        user = "stshalson";
        dataDir = "/home/stshalson/Documents";    # Default folder for new synced folders
        configDir = "/home/stshalson/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };

  fonts.packages = [ 
    pkgs.nerd-fonts.iosevka
    pkgs.ubuntu-sans
    pkgs.roboto

  ];

  security = {
    # Lets pipewire take realtime priority instead of crackling under load.
    rtkit.enable = true;
    # A Secret Service for Brave's passwords; the PAM line unlocks it at login.
    pam.services.greetd.enableGnomeKeyring = true;
  };
  zramSwap.enable = true;


  # Use bitwarden's SSH agent.
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.bitwarden-ssh-agent.sock
  '';
}
