# xegality-vps — Hostinger KVM cloud VPS.
#
# Deliberately NOT built with mkHost: it skips ./modules (desktop, audio,
# rust toolchain, …) and home-manager. Everything it needs is in this file.
{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/minimal.nix") # no docs, no X libs
    ./hardware-configuration.nix
  ];

  # ------------------------------------------------------------------------
  # Boot — legacy BIOS, single disk /dev/sda (confirmed on the VPS).
  # ------------------------------------------------------------------------
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  # copied from Hostinger's image; kernel output goes to the serial port
  # (ttyS0), without it the web console stops at "Booting NixOS"
  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200"
    "earlyprintk=ttyS0,115200"
    "consoleblank=0"
    "memhp_default_state=online"
  ];

  # ------------------------------------------------------------------------
  # Network — Hostinger passes the IP config via a cloud-init CD (sr0,
  # label "cidata"); cloud-init turns it into systemd-networkd config.
  # ------------------------------------------------------------------------
  networking.hostName = "xegality-vps";
  networking.useDHCP = false;
  # cloud-init's 10-cloud-init-eth0.network targets "eth0"; keep that name
  networking.usePredictableInterfaceNames = false;
  services.cloud-init = {
    enable = true;
    network.enable = true;
  };
  networking.firewall.enable = true; # only port 22 (opened by openssh)

  # ------------------------------------------------------------------------
  # SSH — keys or password, no root login.
  # ------------------------------------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.xegality = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpOLPpULacIksH/zMcYxN+G6P77viuNeruaIE3+Mdcf gaz@cybergaz-workstation"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6FqjwuntAitB29eaywckuJQqUe7e2ZCUSY/hVx2ZbF gaz@cybergaz-workstation"
    ];
  };
  programs.fish = {
    enable = true;
    # lands in /etc/fish/config.fish, so ~/.config/fish stays free for overrides
    interactiveShellInit = builtins.readFile ./config.fish;
  };

  # passwordless sudo, also needed for `nixos-rebuild --target-host` deploys
  security.sudo.wheelNeedsPassword = false;

  # ------------------------------------------------------------------------
  # Postgres — the court judgment corpus (Supreme Court + High Court) that
  # xegality-server's dataroom searches. Unix socket only: nothing listens
  # beyond localhost, and the firewall stays port-22-only.
  # ------------------------------------------------------------------------
  services.postgresql = {
    enable = true;
    # Same major as the workstation, so the dump restores without conversion.
    package = pkgs.postgresql_18;
    extensions = ps: [ ps.pgvector ];
    ensureDatabases = [ "courtdb" ];
    ensureUsers = [
      {
        name = "courtdb";
        ensureDBOwnership = true;
      }
    ];
    # Peer auth over the socket, so no database password exists to leak. OS
    # user `xegality` (restores, and the app services) connects as `courtdb`;
    # `sudo -u postgres psql` stays the admin path.
    authentication = lib.mkOverride 10 ''
      # TYPE  DATABASE  USER      METHOD
      local   all       postgres  peer
      local   courtdb   courtdb   peer map=courtdb
    '';
    identMap = ''
      # MAP     OS-USER   ROLE
      courtdb   xegality  courtdb
    '';
    settings = {
      # 31 GB shared with Bun, xegality-server and the embedding sidecar.
      shared_buffers = "8GB";
      effective_cache_size = "20GB";
      # The 4MB default turned broad full-text bitmaps lossy on the workstation.
      work_mem = "32MB";
      # Index builds; the IVFFlat rebuild raises its own session to 12GB.
      maintenance_work_mem = "2GB";
      # NVMe. The corpus was tuned on a spinning disk; these assume seeks are cheap.
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      # Minimal WAL: this is a single node with no replicas, and the corpus is rebuildable from
      # the workstation, so nothing needs replica-level WAL. It also makes CREATE INDEX skip WAL
      # entirely -- the High Court vector index is ~82 GB, and with replica WAL it ran the 400 GB
      # disk out of space mid-build (its sort file and the index itself already need ~160 GB).
      wal_level = "minimal";
      max_wal_senders = 0;
      max_wal_size = "4GB";
      min_wal_size = "1GB";
      # 8 vCPU.
      max_worker_processes = 8;
      max_parallel_workers = 6;
      max_parallel_workers_per_gather = 2;
      max_parallel_maintenance_workers = 4;
      # Short queries: compiling them costs more than it saves.
      jit = false;
    };
  };

  # ------------------------------------------------------------------------
  # Dataroom — xegality-server in its dataroom role (case-law search over the
  # court corpus above) and the query-embedding sidecar it calls. Both listen
  # on loopback only; nginx is the only way in.
  #
  # Deploying a new server build, from the workstation:
  #   nix build <xegality-rs>#xegality-server
  #   nix copy --to ssh-ng://xegality-vps ./result
  #   ssh xegality-vps sudo nix-env -p /nix/var/nix/profiles/xegality-server --set "$(readlink -f result)"
  #   ssh xegality-vps sudo systemctl restart xegality-dataroom
  # Rolling back: sudo nix-env -p /nix/var/nix/profiles/xegality-server --rollback, then restart.
  # ------------------------------------------------------------------------
  # uv's own CPython and the onnxruntime / numpy / tokenizers wheels are
  # ordinary Linux binaries; nix-ld gives them the loader and libraries they expect.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };

  systemd.services.dataroom-embed = {
    description = "BGE-base query embedding for the dataroom";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      XEGALITY_EMBED_ADDR = "127.0.0.1:4200";
      # 8 shared vCPU: 2 threads measured 24 ms per query at a third of all-core CPU cost.
      XEGALITY_EMBED_THREADS = "2";
      XEGALITY_EMBED_CACHE = "/home/xegality/dataroom-embed/model-cache";
    };
    serviceConfig = {
      User = "xegality";
      WorkingDirectory = "/home/xegality/dataroom-embed";
      ExecStart = "/home/xegality/dataroom-embed/.venv/bin/python serve.py";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  systemd.services.xegality-dataroom = {
    description = "xegality-server, dataroom role";
    after = [
      "network-online.target"
      "postgresql.service"
      "dataroom-embed.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      XEGALITY_ROLE = "dataroom";
      XEGALITY_HTTP_ADDR = "127.0.0.1:4100";
      XEGALITY_HTTP_CORS_ALLOWED_ORIGINS = "https://xegality.com,https://www.xegality.com";
      XEGALITY_LOG_FORMAT = "json";
      XEGALITY_DATAROOM_MODE = "local";
      # Unix socket + peer auth: OS user xegality connects as role courtdb, no password.
      XEGALITY_DATAROOM_DB_URL = "postgres://courtdb@localhost/courtdb?host=/run/postgresql";
      XEGALITY_DATAROOM_EMBED_URL = "http://127.0.0.1:4200";
      # Required by the server's config parsing but never used: the dataroom
      # role runs no vault ingestion, so there is nothing to store or embed.
      AWS_S3_BUCKET_NAME = "unused-in-dataroom-role";
      AWS_ACCESS_KEY_ID = "unused";
      AWS_SECRET_ACCESS_KEY = "unused";
      GEMINI_API_KEY = "unused";
    };
    serviceConfig = {
      User = "xegality";
      ExecStart = "/nix/var/nix/profiles/xegality-server/bin/xegality-server";
      # DB_URL (the platform database, for login checks) and ACCESS_KEY (the
      # key Bun signs logins with). Read by systemd as root; keep it 0600.
      EnvironmentFile = "/etc/xegality/dataroom.env";
      Restart = "on-failure";
      RestartSec = 5;
      LimitNOFILE = 65536;
    };
  };

  # ------------------------------------------------------------------------
  # Small-RAM tuning
  # ------------------------------------------------------------------------
  zramSwap.enable = true;

  # ------------------------------------------------------------------------
  # Nix
  # ------------------------------------------------------------------------
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "xegality" ]; # allows `nixos-rebuild --target-host` from the workstation
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];

  time.timeZone = "Asia/Kolkata";

  environment.systemPackages = with pkgs; [
    git # flakes need it
    rsync # resumable transfer of the court database dump from the workstation
    tmux # long jobs (restores, index builds) that must outlive an SSH session
    jq
    neovim # config.fish aliases vim -> nvim
    # config.fish calls these on every interactive start
    zoxide
    direnv
    btop

    tree-sitter

    bun
    nodejs
    python315
    uv
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
    rustc
    cargo

  ];

  # Hostinger's image is NixOS 26.05. Never bump this.
  system.stateVersion = "26.05";
}
