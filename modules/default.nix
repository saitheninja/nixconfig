{ config, pkgs, lib, ... }:

{
    imports = [
        ./fonts.nix
        ./git.nix
        ./locale-za.nix
        ./nixvim.nix
    ];

    configLocaleZa.enable = lib.mkDefault true;
    configSelectedFonts.enable = lib.mkDefault true;
    configGit.enable = lib.mkDefault true;
    configNixvim.enable = lib.mkDefault true;
}