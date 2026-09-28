# Wayland compositors, display manager and fonts.
{ pkgs, inputs, ... }:
{
  # Deliberately `pkgs.hyprland`, with no `package` override: this is the session ly
  # launches, and home/hyprland.nix builds both its config and the hyprscape plugin against
  # the very same derivation. Pointing this at a flake's Hyprland while home-manager kept
  # nixpkgs' is exactly how the two drifted apart before -- read the note in
  # home/hyprland.nix before adding an override here.
  programs.hyprland.enable = true;

  programs.niri = {
    enable = true;
    # niri from the wip flake input, shared by both machines
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      # matrix | none | gameoflife
      animation = "none";
      # The character used to mask the password
      asterisk = "*";
      # Erase password input on failure
      clear_password = true;
      # Remove main box borders
      hide_borders = true;
      # Main box margins
      margin_box_h = 2;
      margin_box_v = 1;
      # Input boxes length
      input_len = 34;
    };
  };

  fonts.packages = with pkgs; [
    comfortaa
    jetbrains-mono
    nerd-fonts.noto
    noto-fonts
  ];
}
