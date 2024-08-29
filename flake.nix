{
  description = "NixOS flake for my machines";

  # `inputs` are the dependencies of the flake.
  # `outputs` function will return all the build results of the flake.

  inputs = {
    nixpkgs-24-05.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts-unstable = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    };
    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-parts.follows = "flake-parts-unstable";
        # not using these inputs
        devshell.follows = "";
        flake-compat.follows = "";
        git-hooks.follows = "";
        home-manager.follows = "";
        nix-darwin.follows = "";
        nuschtosSearch.follows = "";
        treefmt-nix.follows = "";
      };
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself (self-reference)
  #
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  # e.g. `inputs.nix-vscode-extensions`
  outputs =
    {
      # self,
      nixpkgs-24-05,
      nixpkgs-unstable,
      nixvim-unstable,
      nixos-cosmic,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # By default, NixOS will try the nixosConfiguration with its hostname:
        #   sudo nixos-rebuild switch
        # The configuration name can be specified using:
        #   sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
        #   sudo nixos-rebuild switch --flake .#nixos-laptop

        "nixos-laptop" = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";

          # A Nix Module can be an attribute set, or a function that returns an
          # attribute set.
          # if a Nix Module is a function, this function has the following
          # default parameters:
          #  lib:     the nixpkgs function library.
          #  config:  all config options of the current flake.
          #  options: all options defined in all NixOS Modules in the current flake.
          #  pkgs:    a collection of all packages defined in nixpkgs,
          #           plus a set of functions related to packaging.
          #           default `nixpkgs.legacyPackages."${system}"`.
          #           can be customised by `nixpkgs.pkgs` option.
          #  modulesPath: the default path of nixpkgs's modules folder,
          #               used to import some extra modules from nixpkgs.
          #               this parameter is rarely used, you can ignore it for now.
          #
          # The default parameters above are automatically generated by Nixpkgs.
          # If you need to pass other parameters to the submodules, manually
          # configure these parameters using `specialArgs`.
          #  specialArgs = {...};  # pass custom arguments into all sub module.
          modules = [
            ./hosts/laptop/configuration.nix
            ./modules

            ./nixvim
            nixvim-unstable.nixosModules.nixvim

            # Hyprland dynamic tiling Wayland compositor
            (
              { ... }:
              {
                config.configHyprland.enable = true;
              }
            )

            # COSMIC Desktop Environment from Pop!_OS
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            (
              { ... }:
              {
                services.desktopManager.cosmic.enable = true;
                services.displayManager.cosmic-greeter.enable = true;
              }
            )
          ];
        };

        "nixos-desktop" = nixpkgs-24-05.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/desktop/configuration.nix
            ./modules
          ];
        };
      };
    };
}
