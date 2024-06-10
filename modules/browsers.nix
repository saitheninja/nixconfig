{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    configBrowsers.enable = lib.mkEnableOption "Install web browsers.";
  };

  config = lib.mkIf config.configBrowsers.enable {
    programs = {
      chromium = {
        enable = true;

        enablePlasmaBrowserIntegration = true; # media controls, KDE Connect integration, etc.
        extensions = [
          "nngceckbapebfimnlniiiahkandclblb" # bitwarden
          "immpkjjlgappgfkkfieppnmlhakdmaab" # imagus - view images on hover
          "eggkanocgddhmamlbiijnphhppkpkmkl" # tabs outliner
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        ];
      };

      firefox = {
        enable = true;
      };
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      google-chrome
      #ungoogled-chromium
    ];
  };
}
