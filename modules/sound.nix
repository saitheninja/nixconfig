{ config, lib, ... }:

{
  options.configSound.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Pipewire, add some latency optimisations.";
  };

  config = lib.mkIf config.configSound.enable {
    boot.kernel.sysctl = {
      # lower number means use ram more, swap to disk less
      # helps with audio latency
      # min 0, max 200, default 60
      "vm.swappiness" = 10;
    };

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
