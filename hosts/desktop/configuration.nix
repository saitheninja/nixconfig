{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # configNixvim.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-desktop";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;  

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Wayland hinting for electron apps

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # desktop
    piper # mouse controls
    thunderbird
    vlc

    # dev
    docker
    docker-compose
    gh # GitHub CLI
    vscode-fhs

    # game engines
    godot_4

    # image editors
    inkscape # vectors
    gimp # photoshop
    krita # drawing
    #aseprite # pixel art # licence requires building from source
    pixelorama # godot pixel art

    # music
    ardour # daw
    audacity # audio editor & recorder
    bespokesynth # live daw (no VST2 because of licensing)
    calf # effects, instruments, tools
    cardinal # vcv-rack as a fully open source plugin
    carla # plugin host
    dragonfly-reverb # reverb plugins
    guitarix # virtual guitar amp (standalone)
    # helm # unmaintained predecessor to vital synth
    infamousPlugins # LV2 plugins
    lmms # daw
    odin2 # synth
    sorcer # dubstep synth
    surge-XT # synth
    supercollider # programming language
    wolf-shaper # waveshaper plugin
    x42-avldrums # Drum sample player LV2 plugin dedicated to Glen MacArthur's AVLdrums
    x42-plugins # LV2 plugins
    x42-gmsynth # general MIDI sample player LV2 plugin, intended as default synth for Ardour
    yoshimi # synth
    zrythm # daw
    zam-plugins # processing plugins
    zynaddsubfx # synth

    # photo
    #darktable # raw editor
    #vkdt-wayland # darktable fork

    # video
    obs-studio # screen capture
    davinci-resolve-studio # video editing, color, effects, audio

    # 3D
    blender
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses

  #environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
