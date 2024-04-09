
{ config, pkgs, lib, ... }:

{
  options = {
    configGit.enable = lib.mkEnableOption "Adds my git config.";
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
  };
}
