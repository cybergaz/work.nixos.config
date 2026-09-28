-- Animations. https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Legacy `bezier = name, x1, y1, x2, y2` becomes `hl.curve(name, { points = ... })`.

hl.curve("wind",     { type = "bezier", points = { { 0,    1.2 }, { 0,   1    } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1   }, { 0.5, 1    } } })
hl.curve("winIn",    { type = "bezier", points = { { 0.1,  1.1 }, { 0.1, 1.05 } } })
hl.curve("linear",   { type = "bezier", points = { { 1,    1   }, { 1,   1    } } })

hl.config({ animations = { enabled = true } })

-- buttery smooth (popin)
hl.animation({ leaf = "windows",          enabled = true, speed = 2, bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 5, bezier = "default",  style = "popin 90%" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "layers",           enabled = true, speed = 3, bezier = "default",  style = "popin 90%" })
hl.animation({ leaf = "fade",             enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 2, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim",          enabled = true, speed = 3, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 3, bezier = "default",  style = "slidefadevert 15%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "default",  style = "slidefadevert 15%" })

-- Alternative "slide" set, kept from the old config:
-- hl.animation({ leaf = "windows",    enabled = true, speed = 5, bezier = "wind",     style = "slide" })
-- hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4, bezier = "winIn",    style = "slide" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "smoothIn", style = "slide" })
