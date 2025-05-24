{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.configUsersSai.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Add user `sai`.";
  };

  config = lib.mkIf config.configUsersSai.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.sai = {
      isNormalUser = true;
      description = "sai";
      extraGroups = [
        "docker"
        "libvirtd" # VMs
        "networkmanager"
        "uinput" # kanata keyboard remaps
        "wheel" # allow `sudo`
        "wireshark"
      ];

      # packages = with pkgs; [ ]; # user specific packages
      #shell = pkgs.zsh;
      shell = pkgs.fish;
    };

  };
}
