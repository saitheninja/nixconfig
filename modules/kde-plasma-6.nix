{ config, lib, ... }:

{
  options = {
    configKdePlasma6.enable = lib.mkEnableOption "Set up KDE Plasma 6 as desktop environment.";
  };

  config = lib.mkIf config.configKdePlasma6.enable {
    programs.partition-manager.enable = true; # KDE partition manager

    services = {
      desktopManager.plasma6.enable = true;

      displayManager = {
        sddm.enable = true;
        sddm.wayland.enable = true;
      };

      # Enable CUPS to print documents
      printing.enable = true;

      xserver = {
        # Enable the X11 windowing system
        enable = true;

        # Enable touchpad support (enabled default by in most desktopManager)
        # libinput.enable = true;

        # Configure keymap in X11
        xkb = {
          layout = "us";
          variant = "";
          options = "caps:ctrl_modifier"; # make Caps Lock an additional Ctrl
        };
      };
    };
  };
}
