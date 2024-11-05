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

      # TODO check codes with evtest from tty, because it is being captured by something in desktop environment
      # still figuring out some input mappings because laptop has a bunch of inputs and special function keys
      # from `sudo evtest`:
      # Available devices:
      # /dev/input/event0:      AT Translated Set 2 keyboard
      # /dev/input/event1:      Lid Switch
      # /dev/input/event2:      Sleep Button
      # /dev/input/event3:      Power Button
      # /dev/input/event4:      Power Button
      # /dev/input/event5:      MSI WMI hotkeys
      # /dev/input/event6:      SynPS/2 Synaptics TouchPad
      # /dev/input/event7:      Video Bus
      # /dev/input/event8:      Video Bus
      # /dev/input/event9:      HDA Intel PCH Mic
      # /dev/input/event10:     HDA Intel PCH Headphone
      # /dev/input/event11:     HDA Intel PCH HDMI/DP,pcm=3
      # /dev/input/event12:     HDA Intel PCH HDMI/DP,pcm=7
      # /dev/input/event13:     HDA Intel PCH HDMI/DP,pcm=8
      #
      # https://www.toptal.com/developers/keycode
      # https://www.w3.org/TR/uievents-code/
      # https://github.com/jtroo/kanata/blob/3c27ce1aeb327694e26ef939ce8ac96e49ea25af/parser/src/keys/mod.rs#L297
      config = # lisp
        ''
          ;; Only one defsrc is allowed.
          ;; defsrc defines the keys that will be intercepted by kanata.
          ;; The order of the keys matches with deflayer declarations, and all deflayer declarations must have the same number of keys as defsrc.
          ;; Any keys not listed in defsrc will be passed straight to the operating system.

          ;; https://github.com/jtroo/kanata/blob/main/parser/src/keys/mod.rs
          ;;
          ;; prnt = PrintScreen
          ;;
          ;; grv = Backquote (backtick/grave)
          ;; min = Minus
          ;; eql = Equal
          ;; bspc = Backspace
          ;;
          ;; lbrc = BracketLeft ("[")
          ;; rbrc = BracketRight ("]")
          ;; bksl = Backslash
          ;;
          ;; scln = Semicolon
          ;; apo = Quote (apostrophe/single quote)
          ;;
          ;; comm = Comma
          ;; 102d = IntlBackslash (international backslash)
          ;; fn = function key to shift to hardware function shortcut keys
          ;;
          ;; TODO fn key is not defined for linux?
          ;; https://github.com/jtroo/kanata/blob/b1e828b4cda220eda3bc4e0aef2f9afba5fc9b4f/parser/src/keys/mod.rs#L283
          ;; https://github.com/jtroo/kanata/issues/975
          ;; https://github.com/jtroo/kanata/issues/1141
          ;; (defsrc
          ;;   esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  prnt del
          ;;   grv  1    2    3    4    5    6    7    8    9    0    min  eql  bspc home
          ;;   tab  q    w    e    r    t    y    u    i    o    p    lbrc rbrc bksl pgup
          ;;   caps a    s    d    f    g    h    j    k    l    scln apo  ret       pgdn
          ;;   lsft z    x    c    v    b    n    m    comm .    /    rsft      up   end
          ;;   lctl lmet lalt           spc            102d ralt fn   rctl lft  down rght
          ;; )

          (defsrc
            caps a    s    d    h    f    j    k    l
            lsft rsft
          )

          (defvar
            tap-timeout 150
            hold-timeout 150

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


          (deflayermap (default-layer)
            ;; input_key output_action

            ;; `tap-hold`
            ;; One action for a "tap" and a different action for a "hold"
            ;; ((tap timeout in milliseconds) (hold timeout in milliseconds) (tap action) (hold action))
            ;; tap timeout is the number of milliseconds within which a rapid press+release+press of a key will result in the tap action being held instead of the hold action activating

            ;; `tap-hold-press`
            ;; If there is a press of a different key, the hold action is activated even if the hold timeout hasn’t expired yet

            ;; `tap-hold-release`
            ;; If there is a press+release of a different key, the hold action is activated even if the hold timeout hasn’t expired yet

            ;; caps lock key: tap for escape, hold for left control
            caps (tap-hold-press $tap-timeout $hold-timeout esc lctl)

            ;; left/right shift: tap for round bracket open/close (shift+9/0), hold for left/right shift
            lsft (tap-hold-press $tap-timeout $hold-timeout S-9 lsft)
            rsft (tap-hold-press $tap-timeout $hold-timeout S-0 rsft)

            ;; home-row mods
            a @a
            s @s
            d @d
            f @f
            h @h
            j @j
            k @k
            l @l
          )

          ;; mute = volume mute
          ;; volu = volume up
          ;; voldwn = volume down
          ;; brup = brightness up
          ;; brdown = brightness down
          ;; blup = backlight up
          ;; bldn = backlight down
          ;;
          ;; when fn held
          ;; (deflayermap (fn-hardware-controls)
          ;;   f2 (screen-output)
          ;;   f3 (touchpad-toggle)
          ;;   f6 (webcam-toggle)
          ;;   f10 (airplane-mode)
          ;;   f12 (sleep)
          ;;   pgup (backlight-up)
          ;;   pgdn (backlight-down)
          ;;   end (volume-mute)
          ;;   lft (volume-down)
          ;;   rght (volume-up)
          ;;   up (brightness-up)
          ;;   down (brightness-down)
          ;; )

          (deflayermap (no-mods)
            a a
            s s
            d d
            f f
            h h
            j j
            k k
            l l
          )

          (defvirtualkeys
            to-base (layer-switch default-layer)
          )

          (defalias
            same-side (multi
              (layer-switch no-mods)
              (on-idle 20 tap-vkey to-base)
            )

            ;; `tap-hold-release-keys`
            ;; takes a list of keys that trigger an early tap when they are pressed while the tap-hold-release-keys action is waiting

            ;; pressing another key on the same half of the keyboard as the home row mod will activate an early tap action
            ;; when a home row mod activates @same-side, the home row mods are disabled while continuing to type rapidly

            ;; switch to no-mods layer if pressing a key on the same side
            ;; switch back to default-layer after 20ms timeout

            a (tap-hold-release-keys $tap-timeout $hold-timeout (multi a @same-side) lmet $left-hand-keys)
            s (tap-hold-release-keys $tap-timeout $hold-timeout (multi s @same-side) lalt $left-hand-keys)
            d (tap-hold-release-keys $tap-timeout $hold-timeout (multi d @same-side) lctl $left-hand-keys)
            f (tap-hold-release-keys $tap-timeout $hold-timeout (multi f @same-side) lsft $left-hand-keys)
            h (tap-hold-release-keys $tap-timeout $hold-timeout (multi h @same-side) rsft $right-hand-keys)
            j (tap-hold-release-keys $tap-timeout $hold-timeout (multi j @same-side) rctl $right-hand-keys)
            k (tap-hold-release-keys $tap-timeout $hold-timeout (multi k @same-side) ralt $right-hand-keys)
            l (tap-hold-release-keys $tap-timeout $hold-timeout (multi l @same-side) rmet $right-hand-keys)
          )
        '';

      # Without this, tap-hold actions will not activate for keys that are not in defsrc
      extraDefCfg = "process-unmapped-keys yes";
    };
  };

  environment.systemPackages = with pkgs; [
    # desktop
    piper # mouse controls
    thunderbird # email
    vlc # video player

    # dev
    evtest # input event debugging
    evtest-qt # Qt based GUI that provides a list of attached input devices, and displays which axis and buttons are pressed
    ventoy # create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files
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
    #zoom-us # ugh
    #teams-for-linux # unofficial Electron client
    #linuxKernel.packages.linux_6_6.v4l2loopback # kernel module to create virtual V4L2 loopback devices

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
