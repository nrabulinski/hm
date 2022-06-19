{
  config,
  pkgs,
  ...
}: {
  imports = [./helix.nix];

  home.packages = with pkgs; [ripgrep ripgrep-all];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.exa.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = let
      gpgUpdateTty = "gpg-connect-agent updatestartuptty /bye > /dev/null";
    in {
      l = "exa -lah";
      git = "${gpgUpdateTty} && ${pkgs.git}/bin/git";
      ssh = "${gpgUpdateTty} && ${pkgs.openssh}/bin/ssh";
    };
    functions = {fish_prompt = {body = builtins.readFile ./prompt.fish;};};
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
    settings = {default-key = "FF629AA9E08138DB";};
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    sshKeys = ["81CC27083653861F657A23280C32A9B41DAEF9A0"];
  };
}
