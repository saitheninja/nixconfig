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
      # chromium = {
      #   enable = true;
      # };

      firefox = {
        enable = true;
      };
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      #firefox
      chromium
      google-chrome
      #ungoogled-chromium
    ];
  };
}
