{ config, lib, ... }:

{
  options.configNixConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable flakes, allow unfree packages, set store garbage collection, enable store optimisation.";
  };

  config = lib.mkIf config.configNixConfig.enable {
    nix = {
      # garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      settings = {
        # replace identical files in the store with hard links to single copy
        auto-optimise-store = true;

        # enable flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    # required for flakes
    programs.git.enable = true;
  };
}
