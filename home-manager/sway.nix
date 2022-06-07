{ lib, pkgs, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-env";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in {
  programs.foot.enable = true;
    
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      menu = "";
      terminal = "${pkgs.foot}/bin/foot";
      startup = [
        { command = "${dbus-sway-environment}"; }
      ];
    };
  };
    
  services.kanshi.enable = true;
  
  home.sessionVariables.WLR_NO_HARDWARE_CURSORS = 1;
}