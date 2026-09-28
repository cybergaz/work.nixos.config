-- Environment variables.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local vars = require("00-vars")

-- The legacy config used `$HOME` / `$PATH` expansion, which hyprlang did for us.
-- Lua has no such expansion, so build PATH explicitly.
local extraPath = {
    vars.home .. "/.local/bin",
    vars.home .. "/.cargo/bin",
    vars.home .. "/go/bin",
    vars.home .. "/.bun/bin",
    vars.home .. "/.config/composer/vendor/bin",
    vars.home .. "/.local/share/nvim/mason/bin",
}

hl.env("PATH", table.concat(extraPath, ":") .. ":" .. (os.getenv("PATH") or ""))

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-- Cursor
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

-- GPU / video acceleration (nouveau on this box)
hl.env("LIBVA_DRIVER_NAME", "nouveau")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")
-- WLR_NO_HARDWARE_CURSORS is a wlroots knob; Hyprland dropped wlroots for
-- aquamarine in 0.41, so this was a no-op. The real setting now lives in
-- 50-look-and-feel.lua as cursor.no_hardware_cursors.
