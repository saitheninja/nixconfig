{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.configVirtualisation.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Set up Docker, VMs.";
  };

  config = lib.mkIf config.configVirtualisation.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    # https://nixos.wiki/wiki/Virt-manager
    programs.virt-manager.enable = true; # GUI for managing VMs

    virtualisation = {
      docker = {
        enable = true;
        # enableOnBoot = true; # required for `--restart=always` to work
      };

      libvirtd.enable = true; # manage VMs

      # waydroid.enable = true; # Android on Wayland
    };
  };
}
