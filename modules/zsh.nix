{ config, lib, ... }:

{
  options = {
    configZsh.enable = lib.mkEnableOption "Enable customised zsh.";
  };

  config = lib.mkIf config.configZsh.enable {
    programs = {
      zsh = {
        enable = true;

        enableCompletion = true;
        vteIntegration = true;

        # plugins
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
  };
}
