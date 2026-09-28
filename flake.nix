{
  description = "cybergaz unified nixos + home-manager config (laptop + workstation)";

  inputs = {
    # nixpkgs unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, pinned to the same nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri window manager (wip branch) — used by both hosts
    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri-style zoom-out overview built for the scrolling layout, which is what
    hyprscape = {
      url = "git+file:///home/gaz/workspace/cpp/hyprscape";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # fff-nvim = {
    #   url = "github:dmtrKovalenko/fff.nvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      flake-programs-sqlite,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Build a host from a single machine-specific module. Everything that is
      # common to every machine lives in ./modules; the per-machine bits live in
      # ./hosts/<name>. Add a new machine by dropping a folder in ./hosts and
      # adding one line to nixosConfigurations below.
      mkHost =
        hostModule:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = system; }

            # shared configuration (./modules/default.nix)
            ./modules

            flake-programs-sqlite.nixosModules.programs-sqlite

            # home-manager wired in as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "HMBackup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.gaz.imports = [ ./home/home.nix ];
            }

            # the machine-specific module (./hosts/<name>/default.nix)
            hostModule
          ];
        };
    in
    {
      nixosConfigurations = {
        # nixos-rebuild switch --flake ~/nixos-config#cybergaz-laptop
        cybergaz-laptop = mkHost ./hosts/laptop;

        # nixos-rebuild switch --flake ~/nixos-config#cybergaz-workstation
        cybergaz-workstation = mkHost ./hosts/workstation;

        # Hostinger cloud VPS — standalone, skips ./modules and home-manager.
        # nixos-rebuild switch --flake ~/nixos-config#xegality-vps \
        #   --target-host xegality@<vps-ip> --use-remote-sudo
        xegality-vps = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./hosts/vps
          ];
        };
      };
    };
}
