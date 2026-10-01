# caveman — token-compression proxy/skill for AI coding agents.
# https://github.com/JuliusBrussee/caveman
#
# Not in nixpkgs and the repo ships no flake, so this packages the published npm
# tarball directly. That works because @caveman-ai/cli has zero runtime
# dependencies and publishes its compiled dist/, so there is no npm install step
# and no npmDepsHash to keep in sync — just JS + a node wrapper.

{ pkgs, ... }:
let
  version = "1.3.4";

  caveman = pkgs.stdenvNoCC.mkDerivation {
    pname = "caveman";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@caveman-ai/cli/-/cli-${version}.tgz";
      hash = "sha256-MAaNv6eDw7JkLM6H0pKpHRUowrP8qM7OYKyoi3Sl+jw=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/caveman
      cp -r . $out/lib/caveman/
      # Upstream ships both names; `cave` is the short alias.
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/caveman \
        --add-flags $out/lib/caveman/dist/index.js
      ln -s $out/bin/caveman $out/bin/cave
      runHook postInstall
    '';

    meta = {
      description = "Token-compression proxy and skill for AI coding agents";
      homepage = "https://github.com/JuliusBrussee/caveman";
      mainProgram = "caveman";
    };
  };
in
{
  home.packages = [ caveman ];

  # The engine/proxy/mcp Go binaries are NOT packaged here. `caveman setup
  # --install` downloads them from the upstream GitHub release into
  # ~/.caveman/bin and checks them against an embedded ECDSA pubkey. They are
  # statically linked (no PT_INTERP), so they run on NixOS unpatched, without
  # nix-ld or autoPatchelf.
  #
  # Left imperative on purpose: the CLI pins its own binary release and
  # re-downloads on upgrade, so pinning them in the store would just mean two
  # versions to bump instead of one.
}
