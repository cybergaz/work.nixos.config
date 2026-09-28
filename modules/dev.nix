# Toolchains that come from flake inputs/overlays rather than plain nixpkgs.
{ pkgs, inputs, ... }:
{
  # rust toolchain via rust-overlay
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  environment.systemPackages = [
    pkgs.rust-bin.stable.latest.default
    pkgs.rust-analyzer

    # fff.nvim file picker (system-wide binary; the neovim plugin is wired up
    # separately in home/home.nix)
    # inputs.fff-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
