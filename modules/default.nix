{ config, pkgs, lib, ... }:

{
    imports = [
        ./locale-za.nix
        ./selected-fonts.nix
    ];

    localeZa.enable = lib.mkDefault true;
    selectedFonts.enable = lib.mkDefault true;
}