{
  config,
  lib,
  pkgs,
  ...
}:

let
  pkgsMain = with pkgs; [
    wayland-utils # view graphics details in Info Center
    application-title-bar # widget to see application name in title bar
  ];

  pkgsKde = with pkgs.kdePackages; [
    filelight # visualise disk space usage
    #kamoso # webcam # currently marked as broken in nixpkgs
    #kdeconnect-kde # multi-platform app to allow devices to communicate
    #kdenlive # video editor
    kdialog # show nice dialog boxes from shell scripts
    kjournald # provide API and `kjournaldbrowser` for interacting with systemd-journald
    kontrast # contrast checker
    partitionmanager # manage disk devices, partitions and file systems
    plasma-disks # monitor S.M.A.R.T. capable devices
  ];
in

{
  options.configKdePlasma6.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Add Simple Desktop Display Manager (SDDM) and KDE Plasma 6 desktop environment.";
  };

  config = lib.mkIf config.configKdePlasma6.enable {
    environment.systemPackages = pkgsMain ++ pkgsKde;

    # hint electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
        enable = false;

        # Enable touchpad support (enabled by default in most desktopManagers)
        # libinput.enable = true;

        # Configure keymaps
        # xkb = {
        #   layout = "us";
        #   variant = "";
        #   options = "caps:ctrl_modifier"; # make Caps Lock an additional Ctrl
        # };
      };
    };

    xdg.portal = {
      enable = true;

      # Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL=1`
      # This will make `xdg-open` use the portal to open programs
      # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers
      xdgOpenUsePortal = true;
    };
  };
}
