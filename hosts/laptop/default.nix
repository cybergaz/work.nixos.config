# cybergaz-laptop — machine-specific configuration.
# Shared config comes from ../../modules (imported by the flake).
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "cybergaz-laptop";

    # wireless via iwd
    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      IPv6 = {
        Enabled = true;
      };
      Settings = {
        AutoConnect = true;
      };
      General = {
        EnableNetworkConfiguration = true;
      };
    };
  };

  # ------------------------------------------------------------------------
  # Swap and RAM management
  # ------------------------------------------------------------------------
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  # ------------------------------------------------------------------------
  # extra partitions mount config (VAULT data partition)
  # ------------------------------------------------------------------------
  # create a mount point with required permissions
  systemd.tmpfiles.rules = [
    "d /mnt/vault 2775 root storage -"
  ];
  # mount on boot
  fileSystems."/mnt/vault" = {
    device = "/dev/disk/by-label/VAULT";
    fsType = "ext4";
    options = [
      "rw"
      "relatime"
    ];
  };

  # ------------------------------------------------------------------------
  # Power Management (laptop)
  # ------------------------------------------------------------------------
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      # list all modes -> 'cat /sys/devices/system/cpu/cpu0/cpufreq/*'
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      # Optional, helps long-term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };
}
