# System programs, virtualisation and global environment.
{ ... }:
{
  programs.fish.enable = true;
  programs.command-not-found.enable = true;
  # programs.nix-index.enable = true;
  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    # --no-direnv: never drop nix-direnv gcroots of projects not visited recently
    clean.extraArgs = "--keep-since 2d --keep 2 --no-direnv";
    # flake = "/home/gaz/nixos-config"; # sets NH_OS_FLAKE for you
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  environment.localBinInPath = true;
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    FILE_MANAGER = "nemo";
    OZONE_WL = "1"; # Enable ozone wayland support for chromium
    # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    PATH = "$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.bun/bin:$HOME/go/bin";
  };
}
