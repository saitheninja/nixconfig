{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-laptop";

  # Enable networking
  # Choose between wpa_supplicant and networkmanager
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  # fancy keyboard mappings
  #
  # to force exit kanata, press and hold `Left Control + Space + Escape`
  # works on the key input before any remappings done by kanata
  #
  # kanata directly communicates with the system kernel, so it is independent of windowing systems
  # meaning it works across X11, Wayland and Virtual Terminals
  #
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/kanata.nix
  # https://0pointer.net/blog/dynamic-users-with-systemd.html
  # enables `uinput` kernel module, which allows emulating input devices from userspace
  # creates a systemd service for each keyboard
  # creates a DynamicUser named `kanata-${keyboard-name}`
  # adds DynamicUser to groups `input`, `uinput`
  # when service is started, creates dir `/run/kanata-${keyboard-name}`, owned by DynamicUser (dir is removed when service is terminated)
  #
  #
  # About Virtual Terminals
  # `TTY` is short for TeleTYpewriter
  # switch ttys with `Ctrl + Alt + F{1-...}`
  # list all ttys with `ls -l /dev/tty*`: tty, tty0-63, ttyS0-S3 (serial)
  # it is possible to have multiple independent user sessions by using multiple ttys
  # currently it works like this on NixOS (but these are not hard rules):
  # `/dev/tty` represents the terminal for the current process
  # tty1-6 run login session services
  # display manager (SDDM) starts in tty7
  # display manager login spawns desktop environment (Plasma) in tty8
  services.kanata = {
    enable = true;

    keyboards.laptop-kbd = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

      config = # lisp
        ''
          (defsrc
            caps
            lsft rsft
          )

          (defvar
            tap-timeout 100
            hold-timeout 100
            tt $tap-timeout
            ht $hold-timeout
          )

          (deflayermap (default-layer)
            ;; tap caps lock for escape, hold caps lock for left control
            caps (tap-hold-press $tt $ht esc lctl)
            ;; space cadet shifts: tap left/right shift for open/close bracket, hold for left/right shift
            lsft (tap-hold-press $tt $ht S-9 lsft)
            rsft (tap-hold-press $tt $ht S-0 rsft)
          )
        '';

      # Without this, tap-hold-release and tap-hold-press will not activate for keys that are not in defsrc
      extraDefCfg = "process-unmapped-keys yes";
    };
  };
  # services.keyd = {
  #   enable = true;
  #   keyboards = {
  #     default = {
  #       ids = [ "*" ];
  #       settings = {
  #         main = {
  #           capslock = "overload(control, esc)";
  #         };
  #       };
  #     };
  #   };
  # };
  # services.interception-tools = {
  #   enable = true;
  #   plugins = with pkgs.interception-tools-plugins; [ dual-function-keys ];
  #   udevmonConfig =
  #   ''
  #     - JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
  #       DEVICE:
  #         EVENTS:
  #           EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
  #   '';
  # };
  # kmonad not integrated into NixOS, but it has a flake module that can be imported

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Wayland hinting for electron apps

  environment.systemPackages = with pkgs; [
    # desktop
    piper # mouse controls
    thunderbird # email
    vlc # video player

    # dev
    vscode-fhs # vscode, the non-nix way (Filesystem Hierarchy Standard)
    #vscode-with-extensions.override {
    #  vscodeExtensions = with vscode-extensions; [
    # asvetliakov.vscode-neovim
    # bbenoist.nix
    # bierner.emojisense
    # bungcip.better-toml
    # cweijan.vscode-database-client2
    # davidanson.vscode-markdownlint
    # dbaeumer.vscode-eslint
    # dotenv.dotenv-vscode
    # eamodio.gitlens
    # esbenp.prettier-vscode
    # firefox-devtools.vscode-firefox-debug
    # github.github-vscode-theme
    # github.vscode-pull-request-github
    # github.vscode-github-actions
    # jock.svg
    # ms-azuretools.vscode-docker
    # ms-vscode-remote.remote-ssh
    # ms-vscode-remote.remote-containers
    # mkhl.direnv
    # mikestead.dotenv
    # mechatroner.rainbow-csv
    # matthewpi.caddyfile-support
    # redhat.vscode-yaml
    # stylelint.vscode-stylelint
    # svelte.svelte-vscode
    # tamasfe.even-better-toml
    # tomoki1207.pdf
    # usernamehw.errorlens
    # vscode-icons-team.vscode-icons
    # vincaslt.highlight-matching-tag
    # viktorqvarfordt.vscode-pitch-black-theme
    # wix.vscode-import-cost
    # waderyan.gitblame
    #  ]
    #}

    # game engines
    godot_4

    # image editors
    inkscape # vectors
    gimp # photoshop
    krita # drawing

    # music
    ardour # daw
    bespokesynth # live daw
    #guitarix
    lmms # daw
    #cardinal # vcv-rack as a fully open source plugin
    #zrythm

    # photo
    #darktable # raw editor
    #vkdt-wayland # darktable fork

    # video
    obs-studio # screen capture

    # webcam
    guvcview # GTK+ UVC (USB Video device Class) Viewer
    webcamoid # Qt webcam manager
    v4l-utils # video for linux utils
    zoom-us # ugh
    #linuxKernel.packages.linux_6_10.v4l2loopback # kernel module to create virtual V4L2 loopback devices

    # 3D
    #blender
  ];

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
