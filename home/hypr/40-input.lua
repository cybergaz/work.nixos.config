-- Input and devices. See https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
    input = {
        kb_layout = "us",

        -- remap caps to escape. `xkbcli list` shows the full option set.
        kb_options = "caps:escape",
        -- kb_options = "caps:escape, altwin:swap_lalt_lwin, ctrl:swap_ralt_rctl",

        sensitivity  = 0.2, -- mouse cursor
        accel_profile = "adaptive",

        repeat_rate  = 35,
        repeat_delay = 180,

        follow_mouse = 1,
        -- float_switch_override_focus = 0,

        touchpad = {
            natural_scroll = true,
            -- disable_while_typing = true,
            -- clickfinger_behavior = true,
            -- middle_button_emulation = true,
        },
    },
})

-- Per-device config. Find yours with `hyprctl devices | grep touch`.
local ENABLE_TOUCHPAD = true

hl.device({
    name    = "sppt2600:00-0911:5288-touchpad",
    enabled = ENABLE_TOUCHPAD,
})

-- Workspace swipe tuning (legacy `gestures { ... }` block).
hl.config({
    gestures = {
        workspace_swipe_distance           = 200,
        workspace_swipe_min_speed_to_force = 0,
        workspace_swipe_cancel_ratio       = 0,
        workspace_swipe_create_new         = true,
        workspace_swipe_forever            = true,
        -- workspace_swipe_invert  = true,
        -- workspace_swipe_numbered = true,
    },
})
