-- Shared constants for the rest of the config.
-- autoLoad = false: this is required by the other modules, not run on its own.

local M = {}

M.mod = "SUPER"

M.home = os.getenv("HOME") or "/home/gaz"

M.terminal    = "alacritty"
M.termFloat   = "alacritty --config-file ~/.config/alacritty/alacritty.toml -t alacritty_float"
M.fileManager = "nemo"
M.browser     = "firefox"

-- `SUPER + SHIFT`, `SUPER + ALT`, ... spelled out once so binds stay readable.
M.modShift = M.mod .. " + SHIFT"
M.modCtrl  = M.mod .. " + CTRL"
M.modAlt   = M.mod .. " + ALT"

--- Workspace keys, in order, mapped to workspace 1..12.
--- `0` is workspace 10, `minus` 11, `equal` 12 (matching the old hyprland.conf).
M.workspaceKeys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "minus", "equal",
}

return M
