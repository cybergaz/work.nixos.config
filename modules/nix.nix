# Nix daemon settings and global nixpkgs config.
{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Shared by all hosts. Don't bump this without reading the release notes for
  # the version you're moving to — it pins stateful defaults, not the package set.
  # See `man configuration.nix` / https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.11";
}
