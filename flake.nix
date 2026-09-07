{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # flake-parts.url = "github:hercules-ci/flake-parts";
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      mkHost =
        configuration:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ configuration ];
        };
    in
    {
      # The name after '#' in nixos-rebuild; defaults to the hostname if you omit it.
      nixosConfigurations = {
        nixos = mkHost ./hosts/default/configuration.nix;
        konkuter = mkHost ./hosts/konkuter/configuration.nix;
      };
    };
}
