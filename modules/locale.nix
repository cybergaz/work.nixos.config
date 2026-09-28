# Time and clock settings.
{ ... }:
{
  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = false;
  services.timesyncd.enable = true;
  # services.chrony.enable = true;
}
