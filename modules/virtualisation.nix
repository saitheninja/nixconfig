{ config, lib, ... }:

{
  options.configVirtualisation.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Set up Docker, VMs.";
  };

  config = lib.mkIf config.configVirtualisation.enable {
    virtualisation.docker = {
      enable = true;
      # enableOnBoot = true; # required for `--restart=always` to work
    };

    # https://nixos.wiki/wiki/Virt-manager
    virtualisation.libvirtd.enable = true; # manage VMs
    programs.virt-manager.enable = true; # GUI for managing VMs

    # virtualisation.waydroid.enable = true; # Android on Wayland
  };
}
