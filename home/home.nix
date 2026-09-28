{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./wayvnc.nix
  ];

  home.username = "gaz";
  home.homeDirectory = "/home/gaz";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # zip
    # xz
    # unzip
    # p7zip
    # oh-my-zsh
    # oh-my-posh
    # inputs.zen-browser.packages."${system}".twilight
    bibata-cursors
    kora-icon-theme
    orchis-theme
  ];

  # GTK theming
  gtk = {
    gtk4.theme = null;
    enable = true;
    theme.name = "Orchis-Dark";
    iconTheme.name = "kora";
    cursorTheme = {
      # apparently this doesn't work, you have to set it in WM's config
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Orchis-Dark";
        # cursor-theme = "LyraB-cursors";
        # icon-theme = "kora";
        # # font-name = "JetBrains Mono 10";
        # # monospace-font-name = "JetBrains Mono 10";
        # # show-battery-percentage = true;
        # enable-animations = true;
      };
    };
  };

  programs = {

    # basic configuration of git, please change to your own
    git = {
      enable = true;
      settings = {
        user = {
          name = "cybergaz";
          email = "kkanttechy@gmail.com";
        };
        init.defaultBranch = "master";
      };
    };

    # direnv
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
      # never auto-rebuild dev shells; run `nix-direnv-reload` to rebuild
      stdlib = "nix_direnv_manual_reload";
    };

    # obs-studio
    obs-studio.enable = true;

    neovim = {
      enable = true;
      withRuby = false;
      withPython3 = false;
      # plugins = [
      #   fff-nvim.packages.x86_64-linux.fff-nvim
      # ];
      initLua = builtins.readFile ./nvim-init.lua;

    };

  };

  # Global cargo config, applies to every cargo build:
  # - link with mold (from modules/packages.nix)
  # - link against nix-ld's stable /lib64 loader instead of a /nix/store glibc
  #   path, so built binaries survive garbage collection. RUNPATH is dropped
  #   too, otherwise an old store glibc could get mixed with the current loader.
  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    rustflags = [
      "-C", "link-arg=-fuse-ld=mold",
      "-C", "link-arg=-Wl,--dynamic-linker=/lib64/ld-linux-x86-64.so.2",
    ]

    [env]
    NIX_DONT_SET_RPATH_x86_64_unknown_linux_gnu = "1"
  '';

  # home manager release version
  home.stateVersion = "25.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
