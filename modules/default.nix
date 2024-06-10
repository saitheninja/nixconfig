{ lib, ... }:

{
  imports = [
    ./browsers.nix
    ./filesystem-drivers.nix
    ./git.nix
    ./kde-plasma-6.nix
    ./locale-za.nix
    ./nix-conf.nix
    ./nixvim.nix
    ./selected-fonts.nix
    ./zsh.nix
  ];

  configBrowsers.enable = lib.mkDefault true;
  configFilesystemDrivers.enable = lib.mkDefault true;
  configGit.enable = lib.mkDefault true;
  configKdePlasma6.enable = lib.mkDefault true;
  configLocaleZa.enable = lib.mkDefault true;
  configNixConf.enable = lib.mkDefault true;
  configNixvim.enable = lib.mkDefault true;
  configSelectedFonts.enable = lib.mkDefault true;
  configZsh.enable = lib.mkDefault true;
}

