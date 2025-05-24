{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.configTerminal.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Configure shell and aliases, add terminal apps.";
  };

  config = lib.mkIf config.configTerminal.enable {
    environment.shellAliases = {
      cat = "bat";
      ls = "eza --icons=always";

      # shows diffs of all profiles
      nix-profiles-diff-closures = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
      # diff booted and current, so only useful after an update
      nix-store-diff-closures-booted-current = "nix store diff-closures /run/booted-system /run/current-system";
      # example of comparing specific profiles
      #nix-store-diff-closures-profiles = "nix store diff-closures /nix/var/nix/profiles/system-655-link /nix/var/nix/profiles/system-658-link";
    };

    # shell
    programs = {
      fish = {
        enable = true;

        # translate bash scripts to fish
        # oh-my-fish/plugin-foreign-env is unmaintained, so babelfish instead
        useBabelfish = true;

        # some programs provide their own completions
        vendor = {
          config.enable = true;
          completions.enable = true;
          functions.enable = true;
        };
      };

      zsh = {
        enable = false;

        enableCompletion = true;
        vteIntegration = true;

        # plugins
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };
    };

    # terminal apps
    # prefer programs to environment.systemPackages because it has options configured
    programs = {
      starship.enable = true; # pretty shell prompt

      # monitoring
      usbtop.enable = true; # USB activity monitor

      # networking
      wavemon.enable = true; # wifi monitor
      wireshark.enable = true; # network analyzer

    };

    # terminal apps
    environment.systemPackages = with pkgs; [
      # NixOS deps
      curl
      wget
      vim

      # system info, monitoring
      du-dust # disk space (du, but with tree)
      # systeroid # (sysctl, but formatted better)
      btop # system monitor (htop, but formatted better)
      btop-rocm # libs to monitor AMD GPUs
      kmon # kernel manager and activity monitor
      fastfetch # system info (neofetch, but maintained)

      # networking
      netscanner # network monitor (better wavemon?)
      rustscan # port scanner (nmap, but faster, more intuitive)
      whois # DNS lookup

      # fun
      # hollywood # make terminal busy like Mission Impossible
      # rust-stakeholder # make terminal busy like building projects

      # ...rest
      bat # read files as pages (cat, but formatted better)
      eza # list directory (ls, but with colours, icons)
      zathura # terminal PDF viewer
      zellij # terminal multiplexer
    ];
  };
}
