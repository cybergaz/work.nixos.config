# Bluetooth, graphics, audio and input — common to all machines.
{ pkgs, ... }:
{
  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # graphics
  hardware.graphics = {
    enable = true;
  };

  # hardware.nvidia = {
  #  modesetting.enable = true;
  #  open = false;
  #  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  #  };

  services.xserver.videoDrivers = [ "nouveau" ];

  # sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # touchpad / mouse (enabled by default in most desktopManagers)
  services.libinput.enable = true;

}
