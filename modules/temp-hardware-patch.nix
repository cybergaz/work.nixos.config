{ pkgs, inputs, ... }:
let
  # Was reached through `inputs.hyprland.inputs.nixpkgs`, which only ever followed the root
  # nixpkgs anyway -- the hyprland input is gone now (see flake.nix), so say so directly.
  pkgs-unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  hardware.graphics = {
    package = pkgs-unstable.mesa;

    # if you also want 32-bit support (e.g for Steam)
    # enable32Bit = true;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa;
  };
}
