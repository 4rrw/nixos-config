{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
		noctalia.url = "github:noctalia-dev/noctalia";
		noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
	};

	outputs = inputs@{ nixpkgs, ... }: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			modules = [ ./configuration.nix ];
		};
	};
}
