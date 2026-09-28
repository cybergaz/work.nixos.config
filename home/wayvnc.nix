# wayvnc VNC server, run as a user service under the Hyprland session.
#
# Auth/TLS material (~/.config/wayvnc/config, tls_key.pem, tls_cert.pem,
# rsa_key.pem) is deliberately NOT managed here — it's generated once by hand
# and lives only on disk, never in the (world-readable) Nix store or git.
# This unit just execs bare `wayvnc`, which reads that config automatically.
{ pkgs, ... }:
{
  home.packages = [ pkgs.wayvnc ];

  systemd.user.services.wayvnc = {
    Unit = {
      Description = "wayvnc VNC server";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      # --render-cursor: recent wayvnc versions stopped baking the cursor into
      # captured frames by default (sending a separate cursor update instead),
      # which not every client draws correctly. Bake it back into the frame.
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --render-cursor";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
