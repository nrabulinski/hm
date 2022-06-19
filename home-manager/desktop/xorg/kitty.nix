{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      include ./paradise.conf
    '';
  };

  xdg.configFile."kitty/paradise.conf".text = ''
    foreground #E8E3E3
    background #151515
    url_color #E8E3E3

    # black
    color0 #151515
    color8 #424242

    # red
    color1 #B66467
    color9 #B66467

    # green
    color2 #8C977D
    color10 #8C977D

    # yellow
    color3 #D9BC8C
    color11 #D9BC8C

    # blue
    color4 #8DA3B9
    color12 #8DA3B9

    # magenta
    color5 #A988B0
    color13 #A988B0

    # cyan
    color6 #8AA6A2
    color14 #8AA6A2

    # white
    color7 #E8E3E3
    color15 #E8E3E3
  '';
}
