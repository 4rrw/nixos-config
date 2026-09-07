{ pkgs, ... }:
{
  # enable opengl
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # enable amd drivers
  services.xserver.videoDrivers = ["amdgpu"];

  # enable steam, gamescope, mangohud and gamemode
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
  ];
  programs.gamemode.enable = true;
  
  # you have to call protonup imperatively :(
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
