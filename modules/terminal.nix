{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    configTerminal.enable = lib.mkEnableOption "Install zsh, configure aliases, install terminal apps.";
  };

  config = lib.mkIf config.configTerminal.enable {
    environment.shellAliases = {
      cat = "bat";
      ls = "eza --icons=always";
    };

    # prefer programs to environment.systemPackages because it has options configured
    programs = {
      # direnv = {
      #   enable = true;
      #   loadInNixShell = true;
      #   nix-direnv.enable = true;
      # };

      starship.enable = true; # automatically pretty terminal prompt
      usbtop.enable = true; # usb activity monitor
      wavemon.enable = true; # wifi monitor
      wireshark.enable = true; # network analyzer

      zsh = {
        enable = true;

        enableCompletion = true;
        vteIntegration = true;

        # plugins
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # nixos deps
      curl
      wget
      vim

      bat # better cat
      btop # better htop
      du-dust # better du
      eza # better ls
      fastfetch # maintained replacement for neofetch
      lazygit # git client
      # hollywood # fun
      # systeroid # better sysctl
      whois # DNS lookup
      zathura # terminal pdf viewer
      zellij # terminal multiplexer
    ];
  };
}
