{ config, lib, pkgs, ... }:

{
  options = {
    configGit.enable = lib.mkEnableOption "Add my git config.";
  };

  config = lib.mkIf config.configGit.enable {
    programs.git = {
      enable = true;

      config = {
        init.defaultBranch = "main";

        user = {
          email = "saitheninja@gmail.com";
          name = "sai";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      gh # GitHub CLI
    ];
  };
}
