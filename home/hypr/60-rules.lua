-- Window, layer and workspace rules.
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

--------------------------------------------------------------------
-- Layer rules
--------------------------------------------------------------------

hl.layer_rule({
    name         = "waybar",
    match        = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.01,
    animation    = "slide",
})

hl.layer_rule({
    name         = "notifications",
    match        = { namespace = "notifications" },
    blur         = true,
    ignore_alpha = 0.01,
    animation    = "slide",
})

hl.layer_rule({
    name      = "wofi",
    match     = { namespace = "wofi" },
    blur      = true,
    animation = "slide",
})

hl.layer_rule({ name = "gtk-layer-shell", match = { namespace = "gtk-layer-shell" }, blur = true })
hl.layer_rule({ name = "launcher",        match = { namespace = "launcher" },        blur = true })

hl.layer_rule({ name = "no-anim-selection",  match = { namespace = "selection" },  no_anim = true })
hl.layer_rule({ name = "no-anim-hyprpicker", match = { namespace = "hyprpicker" }, no_anim = true })

--------------------------------------------------------------------
-- Workspace rules
--------------------------------------------------------------------

hl.workspace_rule({ workspace = "special", gaps_in = -20 })

--------------------------------------------------------------------
-- Window rules
--------------------------------------------------------------------

-- xwaylandvideobridge should stay invisible and never grab focus
hl.window_rule({
    name             = "xwaylandvideobridge",
    match            = { class = "^(xwaylandvideobridge)$" },
    opacity          = "0 override",
    no_anim          = true,
    no_initial_focus = true,
    max_size         = "1 1",
    no_blur          = true,
})

hl.window_rule({ name = "pavucontrol", match = { class = ".*pavucontrol" }, float = true })

-- floating alacritty scratch terminal
hl.window_rule({
    name    = "alacritty-float",
    match   = { class = "Alacritty", title = "alacritty_float" },
    opacity = "1.05 override",
    float   = true,
    center  = true,
    size    = "1190 604",
})

hl.window_rule({
    name   = "nemo",
    match  = { class = "nemo" },
    float  = true,
    center = true,
    size   = "1190 604",
})

hl.window_rule({
    name    = "btop",
    match   = { class = "Alacritty", title = "btop" },
    opacity = "1.05 override",
    float   = true,
    center  = true,
    size    = "1260 664",
})

-- small always-on-top window titled "fast"
hl.window_rule({
    name    = "fast",
    match   = { title = "fast" },
    float   = true,
    pin     = true,
    opaque  = true,
    move    = "844 40",
    size    = "230 84",
    opacity = "1 1 override",
})

hl.window_rule({
    name      = "telegram",
    match     = { class = ".*telegram.*" },
    float     = true,
    opacity   = "0.9 override",
    size      = "1352 740",
    center    = true,
    workspace = "10",
})

hl.window_rule({
    name   = "iwgtk",
    match  = { class = ".*iwgtk" },
    float  = true,
    size   = "660 600",
    center = true,
})

hl.window_rule({
    name         = "wofi",
    match        = { class = "^wofi$" },
    float        = true,
    center       = true,
    pin          = true,
    opaque       = true,
    opacity      = "0.3 override",
    dim_around   = true,
    stay_focused = true,
    animation    = "popin 95%",
})
