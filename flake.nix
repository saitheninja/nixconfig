{
  description = "Main NixOS flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations = {
     "nixos-laptop" = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # ./hosts/laptop/hardware-configuration.nix
          ./hosts/laptop/configuration.nix
          ./modules
        ];
      };
    };
  };
}
