# This module configures X11 to work with Intel+NVIDIA laptop setup without a mux
# Ref: https://wiki.archlinux.org/title/NVIDIA_Optimus#Use_NVIDIA_graphics_only
#
# This sadly bypasses most of the xorg configuration provided by the NixOS xserver module
#
# TODO: Provide multiple configs to be able to swtich between NVIDIA only and Intel only
# Then it'd be possible to alias multiple commands like
# `startxintel` - `startx -- -config <path to intel-only config>`
{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
    videoDrivers = ["nvidia"];
    layout = "pl";
    displayManager.startx.enable = true;
    config = lib.mkForce ''
      Section "OutputClass"
        Identifier "intel"
        MatchDriver "i915"
        Driver "modesetting"
      EndSection

      Section "OutputClass"
        Identifier "nvidia"
        MatchDriver "nvidia-drm"
        Driver "nvidia"
        Option "AllowEmptyInitialConfiguration"
        Option "PrimaryGPU" "yes"
        ModulePath "${config.hardware.nvidia.package.bin}/lib/xorg/modules"
        ModulePath "${pkgs.xorg.xorgserver}/lib/xorg/modules"
      EndSection
    '';
    exportConfiguration = true;
    libinput.enable = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  };
}
