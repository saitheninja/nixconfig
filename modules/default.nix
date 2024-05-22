{ lib, ... }:

{
  imports = [
    ./browsers.nix
    ./fs-drivers.nix
    ./git.nix
    ./locale-za.nix
    ./nixvim.nix
    ./selected-fonts.nix
    ./zsh.nix
  ];

  configBrowsers.enable = lib.mkDefault true;
  configFilesystemDrivers.enable = lib.mkDefault true;
  configGit.enable = lib.mkDefault true;
  configLocaleZa.enable = lib.mkDefault true;
  configNixvim.enable = lib.mkDefault true;
  configSelectedFonts.enable = lib.mkDefault true;
  configZsh.enable = lib.mkDefault true;
}

