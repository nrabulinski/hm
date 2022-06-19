{pkgs, ...}: {
  imports = [../common.nix ./kitty.nix];

  home.packages = with pkgs; [bemenu transmission];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      terminal = "kitty";
      defaultWorkspace = "workspace number 1";
      modifier = "Mod4";
      startup = [
        {command = "dunst";}
      ];
      menu = "bemenu-run --fn 'DejaVu Sans 15' -c -l 10 -i -w -p 'Run:'";
    };
  };

  # TODO: use autorandr instead of hardcoded `xrandr`
  home.file.".xinitrc".text = ''
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto --output DP-0 --left-of eDP-1-1
    exec i3
  '';
}
