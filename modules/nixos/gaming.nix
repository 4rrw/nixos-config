{ pkgs, inputs, ... }:
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
  programs.steam.extraCompatPackages = [
    inputs.proton-ge.packages.${pkgs.system}.default
  ];
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    # Steam's launch options point at /run/current-system/sw/bin/hypr-gaming
    # because steam does not reliably pick up a fresh PATH after a rebuild, so
    # this has to be a store path rather than a file in ~/bin.
    # writeShellScriptBin and not writeShellApplication: the latter runs
    # shellcheck at build time and rejects the script's `|| true`.
    (writeShellScriptBin "hypr-gaming" (builtins.readFile ./hypr-gaming.sh))
  ];
  programs.gamemode.enable = true;

  # Lets refresh changes inside the VRR range happen without a blank frame.
  boot.kernelParams = [ "amdgpu.freesync_video=1" ];
  
  # you have to call protonup imperatively :(
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
