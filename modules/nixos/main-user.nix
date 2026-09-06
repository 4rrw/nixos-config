{ lib, config, pkgs, ...}:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";
    userName = lib.mkOption {
        type = lib.types.str;
        default = "stshalson";
        description = ''
          username
        '';
      };
  };
  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "main-user";
      # wheel = sudo, networkmanager = manage connections without root.
      # Dropped accidentally in 7c4ab80; without wheel there is no way to
      # run nixos-rebuild at all.
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      initialPassword = "12345";
      shell = pkgs.fish;
    };
  };
}
