{
  description = "NixOS flake for my machines";

  # `inputs` are the dependencies of the flake.
  # `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.

  inputs = {
    nixpkgs-24-05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself(self-reference)
  # 
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs =
    {
      # self,
      nixpkgs-24-05,
      nixpkgs-unstable,
      nixvim-unstable,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # By default, NixOS will try to refer the nixosConfiguration with
        # its hostname.
        # The configuration name can also be specified using:
        #   sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
        #   sudo nixos-rebuild switch --flake .#nixos-laptop

        "nixos-laptop" = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop/configuration.nix
            ./modules
            nixvim-unstable.nixosModules.nixvim
          ];
        };

        "nixos-desktop" = nixpkgs-24-05.lib.nixosSystem {
          system = "x86_64-linux";

          # A Nix Module can be an attribute set, or a function that
          # returns an attribute set. By default, if a Nix Module is a
          # function, this function has the following default parameters:
          #
          #  lib:     the nixpkgs function library, which provides many
          #             useful functions for operating Nix expressions:
          #             https://nixos.org/manual/nixpkgs/stable/#id-1.4
          #  config:  all config options of the current flake, very useful
          #  options: all options defined in all NixOS Modules
          #             in the current flake
          #  pkgs:   a collection of all packages defined in nixpkgs,
          #            plus a set of functions related to packaging.
          #            you can assume its default value is
          #            `nixpkgs.legacyPackages."${system}"` for now.
          #            can be customed by `nixpkgs.pkgs` option
          #  modulesPath: the default path of nixpkgs's modules folder,
          #               used to import some extra modules from nixpkgs.
          #               this parameter is rarely used,
          #               you can ignore it for now.
          #
          # The default parameters mentioned above are automatically generated 
          # by Nixpkgs. However, if you need to pass other non-default 
          # parameters to the submodules, you'll have to manually configure
          # these parameters using `specialArgs`. 
          # specialArgs = {...};  # pass custom arguments into all sub module.

          modules = [
            ./hosts/desktop/configuration.nix
            ./modules
            #({...}:{options.enableNixvim = false;})
          ];
        };
      };
    };
}
