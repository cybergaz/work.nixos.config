# System services and session behaviour shared by all machines.
{ lib, pkgs, ... }:
{
  # Firewall is disabled on both machines.
  networking.firewall.enable = false;

  # cloudflare warp cli
  systemd.services.warp-svc = {
    description = "Cloudflare WARP service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      Restart = "always";
    };
  };

  # postgres for xegality
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    extensions = ps: [ ps.pgvector ];
    dataDir = "/mnt/wd/postgresql/18";
    ensureDatabases = [ "xegality" ];
    ensureUsers = [
      {
        name = "xegality";
        ensureDBOwnership = true;
      }
    ];

    settings = {
      shared_buffers = "8GB";
      effective_cache_size = "20GB";
      max_wal_size = "8GB";
    };
  };
  # for xegality DB
  systemd.services.postgresql.unitConfig.RequiresMountsFor = [ "/mnt/wd" ];
  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/6992e1d6-1673-49fe-b397-c11182a56047";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };
  fileSystems."/mnt/wd" = {
    device = "/dev/disk/by-uuid/32352a48-10d9-4580-9fea-0de79a10d973";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };
  # xegality DB networking
  services.postgresql.settings.listen_addresses = lib.mkForce "*";
  services.postgresql.authentication = pkgs.lib.mkOverride 10 ''
    local all all trust
    host  all all 127.0.0.1/32 scram-sha-256
    host  all all ::1/128      scram-sha-256
    host  all all 192.168.0.0/24 scram-sha-256
  '';
  networking.firewall.allowedTCPPorts = [ 5432 ];

  # lid switch and power key behavior (harmless on the desktop)
  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandlePowerKey = "ignore";
        HandlePowerKeyLongPress = "poweroff";
        HandleSuspendKey = "ignore";
        HandleSuspendKeyLongPress = "hibernate";
      };
    };
  };
}
