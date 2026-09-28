-- General appearance: layout, borders, decoration, blur, misc.
-- See https://wiki.hypr.land/Configuring/Variables/

hl.config({
    general = {
        -- The legacy config set `dwindle` up top and then overrode it with
        -- `scrolling` at the bottom; `scrolling` is what was actually in effect.
        layout = "scrolling",

        gaps_in = 4,
        gaps_out = 20,

        border_size = 1,
        col = {
            active_border = "rgba(0066ff88)",
            inactive_border = "rgba(0055ff00)",
            nogroup_border = "rgba(0055ff00)",
            nogroup_border_active = "rgba(0055ff00)",
        },

        -- resize_on_border       = true,
        -- extend_border_grab_area = 6,
        -- hover_icon_on_border   = true,
    },

    cursor = {
        no_warps = true,
        inactive_timeout = 10,
        sync_gsettings_theme = true,

        -- nouveau's DRM cursor plane misreports the hotspot and drops the
        -- plane whenever the pointer goes idle, so the cursor draws a few px
        -- off from where clicks actually land and blinks out the instant you
        -- stop moving. Compositing it into the frame instead fixes both.
        -- (The old WLR_NO_HARDWARE_CURSORS env var is dead -- Hyprland has
        -- used aquamarine rather than wlroots since 0.41.)
        no_hardware_cursors = true,
    },

    decoration = {
        rounding = 12,

        active_opacity = 1.05,
        inactive_opacity = 0.8,
        fullscreen_opacity = 1.05,

        dim_inactive = true,
        dim_strength = 0.4,
        dim_around = 0.5,
        dim_special = 0.5,

        blur = {
            enabled = true,
            size = 6,
            passes = 3, -- more passes = more resources
            ignore_opacity = true,
            new_optimizations = true,
            noise = 0.015,
            contrast = 1, -- range 0 - 2
            brightness = 1, -- range 0 - 2
            popups = true,
            popups_ignorealpha = 0.8,
            special = false,
            -- vibrancy          = 0.8,
            -- vibrancy_darkness = 0.9,
            -- xray              = true,
        },

        shadow = {
            enabled = false,
            range = 10,
            color = 0x70000000,
        },
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,

        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,

        vrr = 1,

        layers_hog_keyboard_focus = true,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = true,

        close_special_on_empty = true,
        middle_click_paste = false,
        disable_xdg_env_checks = true,
        -- enable_swallow       = true,
    },

    ecosystem = {
        no_update_news = true,
    },

    binds = {
        -- allow_workspace_cycles = true,
    },

    -- Scrolling layout. https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
    scrolling = {
        column_width = 1.0,
    },

    -- Dwindle, kept for when the layout is switched back.
    -- dwindle = {
    --     pseudotile           = true,
    --     preserve_split       = true,
    --     smart_split          = false,
    --     special_scale_factor = 0.9,
    -- },
})
