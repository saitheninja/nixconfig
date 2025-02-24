{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.configSelectedFonts.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Add some hand-selected fonts.";
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
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term # slimmer
      nerd-fonts.iosevka-term-slab # with serifs
    ];
  };
}
