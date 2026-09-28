# cybergaz-workstation — machine-specific configuration.
# Shared config comes from ../../modules (imported by the flake).
{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "cybergaz-workstation";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # NetworkManager needs the user in its group (merged with the shared groups).
  users.users.gaz.extraGroups = [ "networkmanager" ];

  # ------------------------------------------------------------------------
  # GPU disable block — INACTIVE, kept for reference.
  #
  # Uncommenting this makes the machine fully headless (SSH only): the
  # i5-14400F has no integrated graphics, so the GT 740 is the only display
  # hardware. Also comment out services.xserver.videoDrivers in
  # modules/hardware.nix if you ever enable this.
  # ------------------------------------------------------------------------
  # boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  # boot.kernelParams = [ "module_blacklist=nouveau" ];
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{remove}="1"
  # '';

  # ------------------------------------------------------------------------
  # Swap and RAM management
  # ------------------------------------------------------------------------
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GB
    }
  ];

  # ------------------------------------------------------------------------
  # SSH + VNC (wayvnc) reverse tunnels to EC2
  #
  # EC2 has GatewayPorts enabled, so both forwarded ports are reachable on
  # its public IP: 5522 -> this box's sshd, 5900 -> wayvnc (see
  # home/wayvnc.nix for the service; auth/TLS config is set up by hand on
  # this machine, not tracked in git).
  # ------------------------------------------------------------------------
  services.openssh.enable = true;

  # services.tailscale.enable = true;
  # networking.firewall.trustedInterfaces = [ "tailscale0" ];

  systemd.services.reverse-tunnel = {
    description = "Reverse SSH + VNC tunnel to EC2";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "gaz";
      ExecStart = ''
        ${pkgs.autossh}/bin/autossh -M 0 -N \
          -o "ControlMaster=no" \
          -o "ControlPath=none" \
          -o "ServerAliveInterval 30" \
          -o "ServerAliveCountMax 3" \
          -o "ExitOnForwardFailure=yes" \
          -o "StrictHostKeyChecking=no" \
          -i /home/gaz/.ssh/rev-proxy-ssh \
          -R 5522:localhost:22 \
          -R 5900:localhost:5900 \
          ubuntu@52.74.70.114
      '';
      Restart = "always";
      RestartSec = 10;
    };
  };

  # ------------------------------------------------------------------------
  # Tor relay + snowflake proxy
  # ------------------------------------------------------------------------
  services.tor = {
    enable = false;

    # Disable GeoIP to prevent the Tor client from estimating node locations
    enableGeoIP = false;

    # Transparent proxying of applications through Tor
    torsocks.enable = true;

    client = {
      enable = true;
    };

    relay = {
      enable = true;
      role = "relay"; # "relay" | "bridge"
    };

    settings = {
      Nickname = "lumensole";
      ContactInfo = "temp@temp.com";

      # Bandwidth settings
      MaxAdvertisedBandwidth = "100 MB";
      BandWidthRate = "50 MB";
      RelayBandwidthRate = "50 MB";
      RelayBandwidthBurst = "100 MB";

      # Restrict exit nodes to a specific country
      ExitNodes = "{ch} StrictNodes 1";

      # Reject all exit traffic
      ExitPolicy = "reject *:*";

      # Performance and security settings
      CookieAuthentication = true;
      AvoidDiskWrites = 1;
      HardwareAccel = 1;
      SafeLogging = 1;
      NumCPUs = 3;

      # Network settings
      ORPort = [ 443 ];
    };
  };

  # Operating a Snowflake proxy helps others circumvent censorship. Safe to run.
  services.snowflake-proxy = {
    enable = true;
    capacity = 10;
  };

  # ------------------------------------------------------------------------
  # Packages used only on the workstation
  # ------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    stasis
    busybox
    tor-browser
    hostapd
    autossh # used by the reverse-tunnel service above

    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu
  ];

  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # GNOME enables ibus by default, which exports GTK/QT_IM_MODULE=ibus into
  # every session and triggers ibus's "should be called from the desktop
  # session in Wayland" warning under niri. Not needed for plain layouts.
  i18n.inputMethod.enable = lib.mkForce false;

}
