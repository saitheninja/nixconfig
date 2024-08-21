{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.configHyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Add Hyprland desktop environment.";
  };

  config = lib.mkIf config.configHyprland.enable {
    # launch by typing `hyprland` in your tty (DO NOT `sudo hyprland`)
    # also integrates with SDDM
    # config is located in `~/.config/hypr/hyprland.conf`

    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    # hint electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      kitty # hyprland's preferred terminal (`SUPER + Q` to launch)
      dunst # notification daemon
      wofi # app launcher
    ];
  };
}
