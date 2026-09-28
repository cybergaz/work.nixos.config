# Shared configuration imported by every host.
# Anything machine-specific belongs in ./hosts/<name>, not here.
{ ... }:
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./desktop.nix
    ./programs.nix
    ./dev.nix
    ./packages.nix
    ./users.nix
    ./locale.nix
    ./services.nix
    ./temp-hardware-patch.nix
    ./nix.nix
  ];
}
