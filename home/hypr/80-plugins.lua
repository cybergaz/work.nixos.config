-- Plugin configuration and binds.
-- The plugin .so itself is loaded by `hl.plugin.load(...)`, which Home Manager
-- emits at the top of hyprland.lua from `wayland.windowManager.hyprland.plugins`.

local v = require("00-vars")
local mod = v.mod

--------------------------------------------------------------------
-- hyprscape - niri-style zoom-out overview for the scrolling layout
-- ~/workspace/cpp/hyprscape
--------------------------------------------------------------------

-- Zooms the desktop out instead of tiling workspace thumbnails into a grid.
-- Each workspace is one horizontal scroll tape; the tapes stack vertically, and
-- columns scrolled off the viewport stay visible either side of their card.
--
-- Registered as `hyprscape:<name>` dispatchers and, because this is a Lua config,
-- also as `hl.plugin.hyprscape.<name>(arg)`:
--   toggle("all" | "cursor")   open("all" | "cursor")   close("")
--   move("up"|"down"|"left"|"right")                    select("")
--   is_active() -> bool
--
-- These run immediately when called; they do NOT return a dispatcher object.
-- So they must be wrapped in a function -- `hl.bind` accepts a plain Lua
-- function as its action, which is exactly what we want here.
hl.bind(mod .. " + O", function()
    hl.plugin.hyprscape.toggle("all")
end)

-- While the overview is open it handles Escape, Enter, the arrow keys and hjkl
-- itself; every other bind in this config keeps working untouched.

-- NOTE on plugin settings: `hl.plugin.load()` only *records* the path; the
-- plugin is not dlopen'd until the whole config script has finished, so its
-- `plugin:hyprscape:*` keys do not exist on the first pass. Setting them here
-- makes Hyprland report "unknown config key", then load the plugin, clear the
-- error overlay and re-parse -- harmless but noisy, and `--verify-config` will
-- always flag it. The defaults are the intended ones, so there is nothing to
-- set. To tune it, uncomment and expect that first-pass warning:
--
hl.config({
    plugin = {
        hyprscape = {
            -- geometry
            zoom = 0.125, -- workspace card size, as a fraction of the monitor
            workspace_gap = 0.1, -- vertical gap between rows, fraction of monitor height
            auto_fit = 0, -- 0 fixed | 1 one zoom per session | 2 per workspace
            min_zoom = 0.12, -- floor for auto_fit
            fit_rows = 0, -- also fit every workspace row on screen at once

            -- appearance
            backdrop_color = "rgba(16161e00)", -- wallpaper dim; opaque base if layers off
            card_color = "rgba(00000000)", -- band behind every row
            active_row_color = "rgba(00000000)", -- band behind the selected row
            render_background_layers = 1, -- wallpaper, unscaled and unmoved
            render_top_layers = 1, -- waybar, unscaled and unmoved
            active_border_size = 1, -- ring on the centred window
            active_border_color = "rgba(3399ffff)",
            active_border_rounding = -1, -- -1 = follow the window's rounding
            hover_border_size = 0, -- ring on the hovered window
            hover_border_color = "rgba(88bbffff)",
            hover_border_rounding = -1, -- -1 = follow the window's rounding
            window_rounding = -1, -- -1 = scale each window's own rounding

            -- motion
            animation_curve = "smooth", -- "smooth" | "spring" | "inherit" | your own curve name
            animation_speed = 4, -- deciseconds; higher is slower. Springs ignore it
            animation_enabled = 1, -- 0 snaps with no animation at all
            spring_stiffness = 250, -- only for animation_curve = "spring"
            spring_damping = 25, -- raise it to take the bounce out
            spring_mass = 1,

            -- which workspaces get a row
            show_empty = 0, -- also show empty workspaces you are not on
            trailing_workspace = 1, -- keep one empty row at the bottom as a drop target
            new_workspace_hint = 0, -- outline that trailing row

            -- behaviour
            exit_on_click = 1, -- a click picks a target and leaves
            close_on_reload = 1,
            warp_cursor = 0, -- warp the pointer onto what you select
            scroll_speed = 1.0, -- wheel sensitivity when walking rows
            select_button = 272, -- BTN_LEFT
            pan_button = 273, -- BTN_RIGHT, 0 disables
            debug = 0, -- log per-window overview geometry each frame

            -- touchpad
            gestures = {
                enabled = 1,
                open_fingers = 4,
                open_distance = 300,
                open_positive = 0, -- 1 if swiping down should open
            },
        },
    },
})

--------------------------------------------------------------------
-- hyprtasking - the previous overview, currently not loaded
-- https://github.com/raybbian/hyprtasking
--------------------------------------------------------------------
-- Still wired up in flake.nix and home/hyprland.nix. Swap the plugin name in
-- `plugins = [ ... ]` there to bring it back, then restore this bind:
--
-- hl.bind(mod .. " + U", function()
--     hl.plugin.hyprtasking.toggle("all")
-- end)
