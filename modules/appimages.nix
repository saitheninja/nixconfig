{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.configAppImages.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable running of AppImage files.";
  };

  config = lib.mkIf config.configAppImages.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    environment.systemPackages = with pkgs; [
      gearlever # manage AppImages
    ];
  };
}
