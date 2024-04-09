{ config, pkgs, lib, ... }:

{
    imports = [
        ./locale-za.nix
        ./fonts.nix
        ./git.nix
    ];

    configLocaleZa.enable = lib.mkDefault true;
    configSelectedFonts.enable = lib.mkDefault true;
    configGit.enable = lib.mkDefault true;
}