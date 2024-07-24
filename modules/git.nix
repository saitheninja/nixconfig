{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.configGit.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Add my git config.";
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
      lazygit # git client
    ];
  };
}
