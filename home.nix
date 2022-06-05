{ config, pkgs, fenix, ... }:

let
  rustToolchain = pkgs.fenix.complete.withComponents [
    "cargo"
    "clippy"
    "llvm-tools-preview"
    "rust-analyzer-preview"
    "rust-src"
    "rust-std"
    "rustc"
    "rustfmt"
  ];
in {
  nixpkgs.overlays = [ fenix.overlay ];

  home.sessionVariables.EDITOR = "hx";

  home.packages = with pkgs; [ bintools clang lldb rustToolchain mold ];
  home.file.".cargo/config.toml".source =
    (pkgs.formats.toml { }).generate "cargo-config" {
      target.x86_64-unknown-linux-gnu = {
        linker = "clang";
        rustflags = [ "-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/mold" ];
      };
    };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.exa.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = { l = "exa -lah"; };
    functions = { fish_prompt = { body = builtins.readFile ./prompt.fish; }; };
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

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor = {
        true-color = true;
        line-number = "relative";
        mouse = false;
        cursor-shape.insert = "bar";
      };
    };
    languages = [{
      name = "rust";
      language-server = { command = "${rustToolchain}/bin/rust-analyzer"; };
    }];
  };

  programs.gpg = {
    enable = true;
    settings = { default-key = "FF629AA9E08138DB"; };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
    sshKeys = [ "81CC27083653861F657A23280C32A9B41DAEF9A0" ];
  };
}
