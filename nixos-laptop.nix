{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      #(modulesPath + "/installer/scan/not-detected.nix")
      ./configuration.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/278f7081-6bf1-4498-97ad-3912ad4f0a76";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/443A-C355";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ed5ca4a0-0552-4a5f-bcc7-c1257b63c4af"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;



  # From configuration.nix when using channels instead of flakes

  boot.loader = {
    #systemd-boot.enable = true;
    #efi.canTouchEfiVariables = true;
  };

  networking = {
    #hostName = "nixos-laptop";
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant
    #networkmanager.enable = true;
  };
}
