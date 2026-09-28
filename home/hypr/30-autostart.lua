-- Autostart. See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- The legacy `exec-once = ...` lines become one `hyprland.start` hook.

local vars = require("00-vars")

hl.on("hyprland.start", function()
    -- wallpaper rotation
    hl.exec_cmd(vars.home .. "/scripts/waybar/wallpapers_v2.sh")

    -- bar / notifications / input automation
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("ydotoold")

    -- polkit agent + make the session env visible to systemd and D-Bus
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd(vars.home .. "/scripts/hyprland/battery_notify.sh")

    -- clipboard history.
    -- NOTE: never set XDG_CACHE_HOME to $HOME/.cache or this wipes the wrong thing.
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd('rm "' .. vars.home .. '/.cache/cliphist/db"')

    -- hl.exec_cmd(vars.home .. "/scripts/hyprland/touchpad_toggle.sh")
    -- hl.exec_cmd("hypridle")
    -- hl.exec_cmd("kidex")
end)
