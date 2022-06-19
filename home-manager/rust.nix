# TODO: Only use mold on x86_64-linux.
{
  pkgs,
  lib,
  fenix ? null,
  ...
}: let
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
  nixpkgs.overlays = lib.optional (fenix != null) fenix.overlay;

  home.packages = with pkgs; [bintools clang lldb rustToolchain mold];
  home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config" {
    target.x86_64-unknown-linux-gnu = {
      linker = "clang";
      rustflags = ["-C" "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"];
    };
  };

  programs.helix = {
    languages = [
      {
        name = "rust";
        language-server = {command = "${rustToolchain}/bin/rust-analyzer";};
      }
    ];
  };
}
