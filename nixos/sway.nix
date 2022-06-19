{pkgs, ...}: {
  imports = [./desktop.nix];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    gtkUsePortal = true;
  };

  programs.sway.enable = true;
}
