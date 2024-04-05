{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-laptop";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_ZA.UTF-8";
    LC_IDENTIFICATION = "en_ZA.UTF-8";
    LC_MEASUREMENT = "en_ZA.UTF-8";
    LC_MONETARY = "en_ZA.UTF-8";
    LC_NAME = "en_ZA.UTF-8";
    LC_NUMERIC = "en_ZA.UTF-8";
    LC_PAPER = "en_ZA.UTF-8";
    LC_TELEPHONE = "en_ZA.UTF-8";
    LC_TIME = "en_ZA.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:ctrl_modifier"; # make Caps Lock an additional Ctrl
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sai = {
    isNormalUser = true;
    description = "sai";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "neovim";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
      # filesystem drivers
      exfat
      ntfs3g
      # browsers
      chromium
      firefox
      google-chrome
      #ungoogled-chromium
      # terminal
      vim
      wget
      curl
      btop
      fzf
      fastfetch
      #systeroid
      # desktop
      piper # mouse controls
      thunderbird
      vscode-fhs
      # dev
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
      docker
      docker-compose
      godot_4
      # art
      gimp
      krita
      inkscape
      #aseprite
      #pixelorama
      #blender
      #obs-studio
      # music
      #ardour
      #bespokesynth
      #guitarix
      #lmms
      #surge-XT
      #zrythm
      # photography
      darktable
  ];

  fonts.packages = with pkgs; [
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      unicode-emoji
      # monospace
      hack-font
      (nerdfonts.override {
        fonts = [
          "CascadiaCode"
          "FiraCode"
          "Iosevka"
        ];
      })
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      vteIntegration = true;
      # plugins
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          email = "saitheninja@gmail.com";
          name = "sai";
        };
      };
    };

    direnv.enable = true;
    neovim.enable = true;
    partition-manager.enable = true; # KDE partition manager
    starship.enable = true;
    usbtop.enable = true;
    wavemon.enable = true;
    wireshark.enable = true;
  };

  virtualisation.docker.enable = true;


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
