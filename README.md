<div align=center>

# nixos.config

Unified NixOS + Home Manager configuration for all my machines.

</div>

---

## Layout

```
.
├── flake.nix              # inputs + the mkHost helper + the list of machines
├── flake.lock             # pinned input versions
├── home/
│   └── home.nix           # Home Manager config (shared by every machine)
├── modules/               # everything common to every machine
│   ├── default.nix        # imports all of the modules below
│   ├── boot.nix           # boot loader, kernel, zswap, fstrim
│   ├── hardware.nix       # bluetooth, graphics, audio, input
│   ├── desktop.nix        # niri / hyprland / ly / fonts
│   ├── programs.nix       # fish, nh, nix-ld, steam, docker, env vars
│   ├── dev.nix            # rust-overlay toolchain + fff.nvim
│   ├── packages.nix       # shared system packages
│   ├── users.nix          # the `gaz` user + storage group
│   ├── locale.nix         # time / timezone
│   ├── services.nix       # firewall, cloudflare warp, logind
│   └── nix.nix            # nix settings, allowUnfree, stateVersion
└── hosts/                 # the only place machines differ
    ├── laptop/
    │   ├── default.nix              # iwd wifi, tlp/power, /mnt/vault, 16G swap
    │   └── hardware-configuration.nix
    └── workstation/
        ├── default.nix              # networkmanager, ssh + reverse tunnel,
        │                            #   tor relay, hostapd, 32G swap
        └── hardware-configuration.nix
```

How it fits together: `flake.nix` defines `mkHost`, which stacks
`./modules` (shared) + Home Manager + one `./hosts/<name>` (machine-specific)
into a NixOS system. Two machines are wired up: `cybergaz-laptop` and
`cybergaz-workstation`.

## Apply

```sh
# laptop
sudo nixos-rebuild switch --flake ~/nixos-config#cybergaz-laptop

# workstation
sudo nixos-rebuild switch --flake ~/nixos-config#cybergaz-workstation
```

If the flake lives elsewhere, point at that path instead (e.g.
`--flake ~/nixos-experimental/nixos-unified#cybergaz-laptop`).

## Installing on a brand-new machine

1. Do the normal NixOS install, then clone this repo to `~/nixos-config`.
2. Generate hardware config for the new box and drop it in the right host dir:
   ```sh
   sudo nixos-generate-config --show-hardware-config \
     > ~/nixos-config/hosts/<laptop|workstation>/hardware-configuration.nix
   ```
   The committed `hardware-configuration.nix` files describe my *current*
   machines — disk labels (`NIXROOT`, `NIXBOOT`), CPU microcode and kernel
   modules. Always regenerate per machine.
3. If this is a *new* kind of machine, add a folder under `hosts/` and one line
   in `flake.nix`'s `nixosConfigurations`.
4. `sudo nixos-rebuild switch --flake ~/nixos-config#<name>`.

## Notes after the merge

- The laptop hostname changed from `cybergaz` to `cybergaz-laptop` so the
  hostname matches the flake target.
- Both machines now use the same **niri** build (the `wip/branch` flake input).
  The workstation previously used the nixpkgs niri; to go back, set
  `programs.niri.package` per-host instead of in `modules/desktop.nix`.
- Workstation-only packages (`stasis`, `busybox`, `tor-browser`, `hostapd`,
  `autossh`) live in `hosts/workstation/default.nix`. `tree-sitter` is now in
  the shared package list.

## Tips / Troubleshooting

- VIA keyboard recognition error: `chmod 777 /dev/hidraw1`
