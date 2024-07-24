{ lib, ... }:

{
  imports = [
    ./browsers.nix
    ./filesystem-drivers.nix
    ./git.nix
    ./kde-plasma-6.nix
    ./locale-za.nix
    ./nix-config.nix
    ./terminal.nix
    ./selected-fonts.nix
    ./sound.nix
    ./users-sai.nix
    ./virtualisation.nix
  ];

  configBrowsers.enable = lib.mkDefault true;
  configFilesystemDrivers.enable = lib.mkDefault true;
  configGit.enable = lib.mkDefault true;
  configKdePlasma6.enable = lib.mkDefault true;
  configLocaleZa.enable = lib.mkDefault true;
  configNixConfig.enable = lib.mkDefault true;
  configSelectedFonts.enable = lib.mkDefault true;
  configSound.enable = lib.mkDefault true;
  configTerminal.enable = lib.mkDefault true;
  configUsersSai.enable = lib.mkDefault true;
  configVirtualisation.enable = lib.mkDefault true;
}
