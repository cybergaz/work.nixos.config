# System packages common to every machine.
# Machine-specific extras live in ./hosts/<name>/default.nix.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    wget
    jq
    fd
    killall
    tmux

    tree-sitter

    openssl
    sshpass
    websocat
    whois
    dig
    pv
    pstree
    tmate

    alacritty
    waybar
    swayidle
    libnotify
    libgcc
    mako
    ly
    firefox-bin
    google-chrome
    wofi
    btop
    lazygit
    # rustup            # rust comes from rust-overlay in ./dev.nix
    zig
    bun
    nodejs
    python315
    fzf
    unrar
    zip
    unzip
    ripunzip
    ripgrep
    bat
    eza
    xcp
    dust
    gcc
    gnumake
    just
    wl-clipboard
    cliphist
    iwgtk
    nemo
    nautilus
    brightnessctl
    hyprlock
    hyprpicker
    xwayland-satellite
    grim
    slurp
    cloudflare-warp
    zoxide
    mpv
    fastfetch
    onefetch
    awww
    viewnior
    gnome.gvfs
    aria2
    usbutils
    pkg-config
    mold
    clang
    # fast-cli
    playerctl
    ffmpeg
    ncdu
    nvtopPackages.intel
    # caligula # for usb flashing

    awscli2
    go
    code-cursor
    nil
    nixfmt

    telegram-desktop
    discord
    postman
    obsidian
    pavucontrol
    spotify

    wiremix
    impala
    bluetui

    poppler-utils
    tesseract
  ];
}
