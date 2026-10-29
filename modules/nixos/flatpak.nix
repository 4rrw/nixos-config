{ config, pkgs, ... }:

let
  # Snapmaker Orca is not on Flathub; Snapmaker ships the bundle on GitHub releases.
  # To update: bump the version in the url and set hash = "" to get the new one.
  snapmakerOrca = pkgs.fetchurl {
    url = "https://github.com/Snapmaker/OrcaSlicer/releases/download/v2.4.0/Snapmaker_Orca-Linux-flatpak_V2.4.0_x86_64.flatpak";
    hash = "sha256-F+1lyo2lvAgfFtGeMP7okvTvWOtIWJKX9BlBwoFfsBE=";
  };
in
{
  services.flatpak.enable = true;

  # Replaces the exported launcher (same file name, ~/.local/share wins). The bundle's
  # entrypoint forces LC_ALL=C.UTF-8, so WebKit reports navigator.languages as ["C"],
  # which the Home/Device tabs reject ("Load failed: invalid language tag").
  # en_US still uses a decimal point, which is all that override was protecting.
  home-manager.users.${config.main-user.userName}.xdg.dataFile."applications/io.github.Snapmaker.Snapmaker_Orca.desktop".text = ''
    [Desktop Entry]
    Name=Snapmaker Orca
    GenericName=3D Printing Software
    Icon=io.github.Snapmaker.Snapmaker_Orca
    Exec=flatpak run --branch=master --arch=x86_64 --file-forwarding --command=env io.github.Snapmaker.Snapmaker_Orca LC_ALL=en_US.UTF-8 /app/bin/snapmaker-orca @@u %U @@
    Terminal=false
    Type=Application
    MimeType=model/stl;model/3mf;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;application/x-amf;
    Categories=Graphics;3DGraphics;Engineering;
    Keywords=3D;Printing;Slicer;slice;3D;printer;convert;gcode;stl;obj;amf;SLA
    StartupNotify=false
    StartupWMClass=snapmaker-orca
    X-Flatpak=io.github.Snapmaker.Snapmaker_Orca
  '';

  # Adds Flathub (the bundle pulls its GNOME runtime from there) and installs the
  # bundle, reinstalling only when the pinned file changes.
  systemd.services.flatpak-snapmaker-orca = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StateDirectory = "flatpak-snapmaker-orca";
    };
    script = ''
      stamp=/var/lib/flatpak-snapmaker-orca/installed
      flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      if [ "$(cat "$stamp" 2>/dev/null)" != "${snapmakerOrca}" ]; then
        flatpak install --system --noninteractive --reinstall --bundle ${snapmakerOrca}
        echo "${snapmakerOrca}" > "$stamp"
      fi
    '';
  };
}
