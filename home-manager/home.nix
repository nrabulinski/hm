{ config, pkgs, ... }:

{
  imports = [ ./helix.nix ];
  
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.exa.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = { l = "exa -lah"; };
    functions = { fish_prompt = { body = builtins.readFile ./prompt.fish; }; };
    interactiveShellInit = ''
      gpg-connect-agent updatestartuptty /bye > /dev/null
    '';
  };

  programs.git = {
    enable = true;
    userName = "Nikodem Rabuliński";
    userEmail = "nikodem@rabulinski.com";
    difftastic.enable = true;
    signing = {
      key = "FF629AA9E08138DB";
      signByDefault = true;
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.gpg = {
    enable = true;
    settings = { default-key = "FF629AA9E08138DB"; };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    sshKeys = [ "81CC27083653861F657A23280C32A9B41DAEF9A0" ];
  };
}
