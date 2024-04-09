{ config, pkgs, lib, ... }:

{
    imports = [
        ./locale-za.nix
        ./fonts.nix
    ];

    localeZa.enable = lib.mkDefault true;
    fontsSelected.enable = lib.mkDefault true;
}