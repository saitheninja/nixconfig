{
  description = "NixOS flake for my machines";

  # `inputs` are the dependencies of the flake.
  # `outputs` function will return all the build results of the flake.

  inputs = {
    nixpkgs-24-05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixvim-config.url = "github:saitheninja/nixvim-config";

    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
  };

  # Parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself (self-reference).
  #
  # `@` is used to alias the attribute set provided as the function inputs,
  # making it convenient to use inside the function.
  # e.g. `inputs.nixpkgs-unstable`
  outputs =
    {
      # self,
      # nixos-cosmic,
      nixpkgs-24-05,
      nixpkgs-unstable,
      nixvim-config,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      # By default, NixOS will try the nixosConfiguration with its hostname:
      #   sudo nixos-rebuild switch
      # The configuration name can be specified using `{path}#{name}`:
      #   sudo nixos-rebuild switch --flake /path/to/flakes/directory#<name>
      #   sudo nixos-rebuild switch --flake .#nixos-laptop

      nixosConfigurations = {
        "nixos-laptop" = nixpkgs-unstable.lib.nixosSystem {
          inherit system;

          # A Nix Module can be an attribute set, or a function that returns an attribute set.
          # if a Nix Module is a function, this function has the following default parameters:
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
          # If you need to pass other parameters to the submodules,
          # manually configure these parameters using `specialArgs`.
          #  specialArgs = {...};  # pass custom arguments into all submodules.

          modules = [
            ./hosts/laptop/configuration.nix
            ./modules

            # NixVim
            {
              environment.systemPackages = [ nixvim-config.packages.${system}.default ];
              environment.variables.EDITOR = "nvim"; # set as default editor
            }

            # Hyprland: Wayland dynamic tiling compositor
            # { config.configHyprland.enable = true; }

            # COSMIC Desktop Environment from Pop!_OS
            # {
            #   nix.settings = {
            #     substituters = [ "https://cosmic.cachix.org/" ];
            #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            #   };
            # }
            # nixos-cosmic.nixosModules.default
            # {
            #   services.desktopManager.cosmic.enable = true;
            #   services.displayManager.cosmic-greeter.enable = true;
            # }
          ];
        };

        "nixos-desktop" = nixpkgs-24-05.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/desktop/configuration.nix
            ./modules
          ];
        };
      };
    };
}
