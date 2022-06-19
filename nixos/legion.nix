{
  config,
  lib,
  pkgs,
  modulesPath,
  user,
  ...
}: {
  imports = [
    ./common.nix
    ./desktop.nix
    ./nvidia.nix
    ./hp.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["btrfs"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "uas"];
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-label/LUKS";
  boot.kernelModules = ["kvm-intel"];

  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "legion";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.useDHCP = lib.mkDefault true;

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  services.usbmuxd.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };

  users.users.${user}.extraGroups = ["libvirtd"];
  services.udisks2 = {
    enable = true;
    settings = {
      "udisks2.conf" = {
        defaults = {
          encryption = "luks2";
          ntfs_defaults = "uid=$UID,gid=$GID";
          ntfs_allow = "uid=$UID,gid=$GID,umask,dmask,fmask,locale,norecover,ignore_case,compression,nocompression,big_writes,nls,nohidden,sys_immutable,sparse,showmeta,prealloc";
        };
        udisks2 = {
          modules = ["*"];
          modules_load_preference = "ondemand";
        };
      };
    };
  };

  system.stateVersion = "22.05";

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # TODO: Manage those sanely
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/730d5f4d-35fc-445a-a093-a25db76da899";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/730d5f4d-35fc-445a-a093-a25db76da899";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/730d5f4d-35fc-445a-a093-a25db76da899";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/730d5f4d-35fc-445a-a093-a25db76da899";
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd" "noatime"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/730d5f4d-35fc-445a-a093-a25db76da899";
    fsType = "btrfs";
    options = ["subvol=log" "compress=zstd" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/SWAP";}
  ];
}
