{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.configKdePlasma6.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Set KDE Plasma 6 as desktop environment.";
  };

  config = lib.mkIf config.configKdePlasma6.enable {
    programs.partition-manager.enable = true; # KDE partition manager
    environment.systemPackages = with pkgs; [
      wayland-utils # view graphics details in Info Center
    ];

    services = {
      desktopManager.plasma6.enable = true;

      displayManager = {
        defaultSession = "plasma"; # wayland: "plasma", X11: "plasmax11"
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };

      # Enable CUPS
      printing.enable = true;

      xserver = {
        # Enable X11 windowing system
        enable = true;

        # Enable touchpad support (enabled by default in most desktopManagers)
        # libinput.enable = true;

        # Configure keymaps
        xkb = {
          layout = "us";
          variant = "";
          options = "caps:ctrl_modifier"; # make Caps Lock an additional Ctrl
        };
      };
    };

    xdg.portal = {
      enable = true;
      # Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`.
      # This will make `xdg-open` use the portal to open programs, which resolves bugs 
      # involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
      xdgOpenUsePortal = true;
    };
  };
}
