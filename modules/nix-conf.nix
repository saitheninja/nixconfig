{ config, lib, ... }:

{
  options = {
    configNixConf.enable = lib.mkEnableOption "Enable flakes, store garbage collection, store optimisation.";
  };

  config = lib.mkIf config.configNixConf.enable {
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

    # required for flakes
    programs.git.enable = true;
  };
}
