{ config, pkgs, ... }:

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
  nixpkgs.overlays = [
    (
      let
        fenix = builtins.fetchTarball {
          url = "https://github.com/nix-community/fenix/archive/8dccfbe51a8adea643ec29a4ec516499a5a081c6.tar.gz";
          sha256 = "1nckkl9m6f28ifbk6dgvzyjxf41bja7iinpf3j0p18zfsz3v7qzs";
        };
      in import "${fenix}/overlay.nix"
    )
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.sessionVariables.EDITOR = "hx";
  
  home.packages = with pkgs; [
    lldb
    rustToolchain
  ];

  programs.home-manager.enable = true;
  programs.exa.enable = true;

  programs.fish = {
    enable = true;
    functions = {
      l = {
        wraps = "exa";
        description = "alias l=exa -lah";
        body = "exa -lah $argv";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Nikodem Rabuliński";
    userEmail = "nikodem@rabulinski.com";
    difftastic.enable = true;
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
    languages = [
      {
        name = "rust";
        language-server = {
            command = "${rustToolchain}/bin/rust-analyzer";
        };
        debugger = {
          name = "rust-lldb";
          transport = "stdio";
          command = "${rustToolchain}/bin/rust-lldb";
        };
      }
    ];
  };
    
  programs.gpg = {
    enable = true;  
    settings = {
      default-key = "FF629AA9E08138DB";
    };
  };
    
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "tty";  
    sshKeys = [
      "81CC27083653861F657A23280C32A9B41DAEF9A0"
    ];
  };
}
