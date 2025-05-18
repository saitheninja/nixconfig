{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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

  hardware.bluetooth.enable = true;

  services.kanata = {
    enable = true;

    keyboards.all-kbds = {
      # all devices
      devices = [ ];

      config = # lisp
        ''
          (defsrc
            a    s    d    f    j    k    l    scln
          )

          (deflayermap (default)
            ;; input_key output_action

            ;; home-row mods
            a @a
            s @s
            d @d
            f @f

            j @j
            k @k
            l @l
            scln @scln
          )

          (deflayermap (home-row-mods-off)
            ;; home row mods off
            a a
            s s
            d d
            f f
            j j
            k k
            l l
            scln scln
          )

          (defvar
            left-hand-keys (
              q w e r t
              a s d f g
              z x c v b
            )

            right-hand-keys (
              y u i o p
              h j k l scln
              n m , . /
            )
          )

          (defvirtualkeys
            to-base (layer-switch default)
          )

          (defalias
            ;; home row mods
            ;; switch back to default-layer after 20ms timeout
            same-side (multi
              (layer-switch home-row-mods-off)
              (on-idle 20 tap-vkey to-base)
            )
            ;; left
            a (tap-hold-release-keys 200 200 (multi a @same-side) lalt $left-hand-keys)
            s (tap-hold-release-keys 200 200 (multi s @same-side) lmet $left-hand-keys)
            d (tap-hold-release-keys 200 200 (multi d @same-side) lctl $left-hand-keys)
            f (tap-hold-release-keys 200 200 (multi f @same-side) lsft $left-hand-keys)
            ;; right
            j (tap-hold-release-keys 200 200 (multi j @same-side) rsft $right-hand-keys)
            k (tap-hold-release-keys 200 200 (multi k @same-side) rctl $right-hand-keys)
            l (tap-hold-release-keys 200 200 (multi l @same-side) rmet $right-hand-keys)
            scln (tap-hold-release-keys 200 200 (multi scln @same-side) ralt $right-hand-keys)
          )
        '';

      # Without this, tap-hold actions will not activate for keys that are not in defsrc
      extraDefCfg = "process-unmapped-keys yes";
    };
  };

  environment.systemPackages = with pkgs; [
    # desktop
    piper # mouse controls
    thunderbird
    vlc

    # dev
    vscode-fhs # the remote SSH is nice
    postman # API requests
    mysql-workbench # connect to remote, with a GUI

    # games
    discord
    heroic # launcher for Epic Games

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
    faust # Functional Audio Stream is a functional programming language for sound synthesis and audio processing
    faustlive # prototyping environment for the Faust language
    guitarix # virtual guitar amp (standalone)
    # helm # unmaintained predecessor to vital synth
    helvum # GTK patchbay for pipewire
    infamousPlugins # LV2 plugins
    lmms # daw
    odin2 # synth
    qpwgraph # Qt graph manager for PipeWire, similar to QjackCtl
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
    darktable # raw editor
    vkdt-wayland # darktable fork

    # video
    obs-studio # screen capture
    #davinci-resolve-studio # video editing, color, effects, audio

    # 3D
    blender

    # Proton
    protonplus
    protonup-qt
  ];

  # Steam
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server

    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };
  hardware.graphics.enable32Bit = true; # Enables support for 32bit libs that steam uses

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
