{ config, lib, ... }:

{
  options = {
    configZsh.enable = lib.mkEnableOption "Enable customised zsh.";
  };

  config = lib.mkIf config.configSelectedFonts.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        vteIntegration = true;

        shellAliases = {
          cat = "bat";
          ls = "eza --icons=always";
        };

        # plugins
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
    };
  };
}
