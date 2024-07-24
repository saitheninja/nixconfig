{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.configFilesystemDrivers.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Add filesystem drivers for exFAT, NTFS.";
  };

  config = lib.mkIf config.configFilesystemDrivers.enable {
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
    ];
  };
}
