{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [dunst libnotify bemenu transmission];

  programs.rofi.enable = true;

  programs.mpv.enable = true;

  services.flameshot.enable = true;
}
