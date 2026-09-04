{ lib, config, pkgs, ...}:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";
    userName = lib.mkOption {
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
      initialPassword = "12345";
      shell = pkgs.fish;
    };
  };
}
