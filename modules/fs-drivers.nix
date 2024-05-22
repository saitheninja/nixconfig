{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    configFilesystemDrivers.enable = lib.mkEnableOption "Install extra filesystem drivers.";
  };

  config = lib.mkIf config.configFilesystemDrivers.enable {
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
    ];
  };
}
