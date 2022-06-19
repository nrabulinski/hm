{
  lib,
  pkgs,
  ...
}: let
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
  programs.foot = {
    enable = true;
    settings = {
      colors = {
        foreground = "E8E3E3";
        background = "151515";

        regular0 = "151515"; # Black
        regular1 = "B66467"; # Red
        regular2 = "8C977D"; # Green
        regular3 = "D9BC8C"; # Yello
        regular4 = "8DA3B9"; # Blue
        regular5 = "A988B0"; # Magenta
        regular6 = "8AA6A2"; # Cyan
        regular7 = "E8E3E3"; # White

        bright0 = "424242"; # Black
        bright1 = "B66467"; # Red
        bright2 = "8C977D"; # Green
        bright3 = "D9BC8C"; # Yello
        bright4 = "8DA3B9"; # Blue
        bright5 = "A988B0"; # Magenta
        bright6 = "8AA6A2"; # Cyan
        bright7 = "E8E3E3"; # White
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      menu = "";
      terminal = "${pkgs.foot}/bin/foot";
      startup = [
        {command = "${dbus-sway-environment}";}
      ];
    };
  };

  services.kanshi.enable = true;

  home.sessionVariables.WLR_NO_HARDWARE_CURSORS = 1;
}
