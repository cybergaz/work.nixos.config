# The primary user account. Hosts may append to extraGroups (e.g. the
# workstation adds "networkmanager") and list options merge automatically.
{ pkgs, ... }:
{
  users.users.gaz = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "docker"
      "storage"
    ];
    shell = pkgs.fish;
  };

  # group used to share access to extra mount points (e.g. /mnt/vault)
  users.groups.storage = { };
}
