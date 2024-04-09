{ config, pkgs, lib, ... }:

{
  options = {
    configSelectedFonts.enable = lib.mkEnableOption "Installs my hand-selected fonts.";
  };

  config = lib.mkIf config.localeZa.enable {
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
      hack-font
      # specific nerd fonts because the package is huge
      (nerdfonts.override {
        fonts = [
          "CascadiaCode"
          "FiraCode"
          "Iosevka"
        ];
      })
    ];
  };
}
