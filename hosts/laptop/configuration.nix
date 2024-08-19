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

  ### fancy keyboard mappings
  #
  # https://github.com/jtroo/kanata
  # communicates directly with the system kernel
  # so it is independent of windowing systems
  # meaning it works in X11, Wayland and Virtual Terminals
  # also works across Linux, macOS and Windows
  #
  # to force exit kanata, press and hold `Left Control + Space + Escape`
  # works on the key input before any remappings done by kanata
  #
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/kanata.nix
  # https://github.com/NixOS/nixpkgs/blob/c3aa7b8938b17aebd2deecf7be0636000d62a2b9/nixos/modules/services/hardware/kanata.nix#L194
  # enables `uinput` kernel module, which allows emulating input devices from userspace
  #
  # https://github.com/NixOS/nixpkgs/blob/c3aa7b8938b17aebd2deecf7be0636000d62a2b9/nixos/modules/services/hardware/kanata.nix#L112
  # creates a systemd service for each keyboard, named `kanata-${keyboard-name}.service`
  # creates a DynamicUser for each keyboard, named `kanata-${keyboard-name}`
  # `SupplementaryGroups=input,uinput` so DynamicUser can read physical inputs and send emulated inputs
  # `RuntimeDirectory=kanata-${keyboard-name}` to create temp dir `kanata-${keyboard-name}` in `/run/`
  # dir `/run/kanata-${keyboard-name}` owned by DynamicUser, created when service is started, removed when service is stopped
 
  ### About systemd
  #
  # https://0pointer.net/blog/dynamic-users-with-systemd.html
  # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=
  # `DynamicUser=`
  # Takes a boolean parameter.
  # If set, a UNIX user and group pair is allocated dynamically when the unit is started, and released as soon as it is stopped.
  # The user and group will not be added to `/etc/passwd` or `/etc/group`, but are managed transiently during runtime.
  # Do not leave files or directories owned by these users/groups around, as a different unit might get the same UID/GID assigned later on, and thus gain access to these files or directories.
  # Use `RuntimeDirectory=` in order to assign a writable runtime directory to a service, owned by the dynamic user/group and removed automatically when the unit is terminated.
  # Use `StateDirectory=`, `CacheDirectory=` and `LogsDirectory=` in order to assign a set of writable directories for specific purposes to the service in a way that they are protected from vulnerabilities due to UID reuse.
  
  ### About Virtual Terminals
  #
  # `TTY` is short for TeleTYpewriter
  # it is possible to have multiple independent user sessions by using multiple ttys
  #
  # switch ttys with `Ctrl + Alt + F{1-...}`
  # list all ttys with `ls -l /dev/tty*`: tty, tty0-63, ttyS0-S3 (serial)
  #
  # currently it works like this on NixOS (but these are not hard rules):
  # - `/dev/tty` represents the terminal for the current process
  # - tty1-tty6 run login session services
  # - display manager (SDDM) starts in tty7
  # - display manager login spawns desktop environment (Plasma) in tty8
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
            tap-timeout 200
            hold-timeout 200
            tt $tap-timeout
            ht $hold-timeout
          )

          (deflayermap (default-layer)
            ;; caps lock key: tap for escape, hold for left control
            caps (tap-hold-press $tt $ht esc lctl)
            ;; left/right shift: tap for open/close round bracket (shift+9/0), hold for left/right shift
            lsft (tap-hold-press $tt $ht S-9 lsft)
            rsft (tap-hold-press $tt $ht S-0 rsft)
          )
        '';

      # Without this, tap-hold-release and tap-hold-press will not activate for keys that are not in defsrc
      extraDefCfg = "process-unmapped-keys yes";
    };
  };

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
