{ config, pkgs, lib, ... }:

{
    imports = [
        ./locale-za.nix
        ./fonts.nix
    ];

    configLocaleZa.enable = lib.mkDefault true;
    configSelectedFonts.enable = lib.mkDefault true;
}