# Shared by every host; anything machine-specific goes in hosts/<name>/configuration.nix.

{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/nixos/main-user.nix
    ../../modules/nixos/nautilus.nix
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

  # GAMING
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = ["amdgpu"];

  # Gives prebuilt dynamic binaries, like nvim-treesitter's parsers, a linker to find.
  programs.nix-ld.enable = true;

  # manylinux Python wheels link these by soname and expect the distro to supply them.
  # opencv-python needs every one: glib and libGL for the core module, the X11 set for
  # its bundled Qt platform plugin.
  # TODO: use things like this in project flake, not system wide
  programs.nix-ld.libraries = with pkgs; [
    glib
    libGL
    libice
    libsm
    libx11
    libxext
    libxcb
  ];

  main-user.enable = true;
  main-user.userName = "stshalson";

  nixpkgs.config.allowUnfree = true;

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
    docker
    # fancy nix tool
    nh
    # larp tools
    fastfetch
    btop
    # -- 
    ffmpeg-full
    brave
    claude-code
    starship
    eza
    bitwarden-desktop
    mpv
    localsend
    tldr
    zoxide
    xournalpp
    p7zip
    unzip
    gparted
    alsa-utils # for debugging audio routing
    xdg-user-dirs # creates and maintains ~/Pictures and friends
    satty # noctalia pipes screenshots here to annotate them
    hyprpicker # the SUPER+PRINT colour picker; noctalia has no equivalent
    bibata-cursors # only here because a theme has to be a store path; hypr/looknfeel.lua picks it
    #
    spotify
    ncspot
    # -- fonts
    ubuntu-sans
    roboto
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.NH_FLAKE = "/home/stshalson/.config/nixos";


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

  # ghostty.conf asks for Iosevka Nerd Font Mono; without it ghostty falls back
  # to proportional DejaVu Sans and every Nerd Font glyph renders as tofu.
  fonts.packages = [ pkgs.nerd-fonts.iosevka ];

  # Lets pipewire take realtime priority instead of crackling under load.
  security.rtkit.enable = true;

  # A Secret Service for Brave's passwords; the PAM line unlocks it at login.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.printing.enable = true;
  services.fwupd.enable = true;
  zramSwap.enable = true;

  # Mounts removable media. No automounter on purpose -- click the disk in the
  # file manager, or `udisksctl mount -b`. gvfs lives in nautilus.nix.
  services.udisks2.enable = true;

  # mDNS, so SMB/NFS hosts turn up in the file manager by name. Opens UDP 5353.
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
