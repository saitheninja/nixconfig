{ config, pkgs, lib, ... }:

{
    imports = [
        ./locale-za.nix
    ];

    localeZa.enable = lib.mkDefault true;
}