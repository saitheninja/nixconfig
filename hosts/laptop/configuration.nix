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

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Wayland hinting for electron apps

  environment.systemPackages = with pkgs; [
    # desktop
    piper # mouse controls
    thunderbird # email
    vlc # video player

    # dev
    docker
    docker-compose
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
    darktable # raw editor
    #vkdt-wayland # darktable fork

    # video
    obs-studio # screen capture

    # webcam
    guvcview # GTK+ UVC (USB Video device Class) Viewer
    webcamoid # Qt webcam manager
    v4l-utils # video for linux utils
    zoom-us # ugh
    linuxKernel.packages.linux_6_10.v4l2loopback # kernel module to create virtual V4L2 loopback devices

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
