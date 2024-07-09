{ config, pkgs, lib, ... }:

{
  options = {
    configSelectedFonts.enable = lib.mkEnableOption "Install my hand-selected fonts.";
  };

  config = lib.mkIf config.configSelectedFonts.enable {
    fonts.packages = with pkgs; [
      # latin fonts
      liberation_ttf
      noto-fonts

      # cjk characters
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # emoji
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      unicode-emoji

      # monospace
      cascadia-code # built in support for Nerd Font (NF) and Powerline (PL) symbols
      hack-font

      # specific nerd fonts because the package is huge
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Iosevka"
        ];
      })
    ];
  };
}
