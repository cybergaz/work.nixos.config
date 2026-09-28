# Boot loader, kernel and low-level RAM/swap tuning.
{ pkgs, ... }:
{
  # ------------------------------------------------------------------------
  # Boot Loader
  # ------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  # boot.plymouth.enable = true;

  boot.kernelParams = [
    # Intel iGPU force-probe — both current machines use the same Alder/Raptor
    # Lake iGPU. Re-check this id with `lspci -nn | grep VGA` on new hardware.

    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # faster + efficient
    "zswap.max_pool_percent=20" # up to 20% of RAM for compressed pages
    # "zswap.zpool=z3fold" # 3 compressed pages per physical page frame.
  ];

  # SSD periodic trim
  services.fstrim.enable = true;
}
