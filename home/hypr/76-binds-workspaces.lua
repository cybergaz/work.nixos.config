-- Workspace switching and moving windows between workspaces.

local v   = require("00-vars")
local mod = v.mod

--------------------------------------------------------------------
-- Relative workspace movement
--------------------------------------------------------------------

hl.bind(mod .. " + J",        hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + K",        hl.dsp.focus({ workspace = "e-1" }))
hl.bind(v.modShift .. " + J", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(v.modShift .. " + K", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(v.modShift .. " + N", hl.dsp.focus({ workspace = "empty" }))

--------------------------------------------------------------------
-- Numbered workspaces 1..12
--   SUPER       + key  -> switch
--   ALT         + key  -> move window (and follow)
--   SUPER SHIFT + key  -> move window silently (stay put)
--------------------------------------------------------------------

for i, key in ipairs(v.workspaceKeys) do
    hl.bind(mod .. " + " .. key,        hl.dsp.focus({ workspace = i }))
    hl.bind("ALT + " .. key,            hl.dsp.window.move({ workspace = i }))
    hl.bind(v.modShift .. " + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

--------------------------------------------------------------------
-- Named "solitude" workspace (bound to the key left of 1, keycode 49)
--------------------------------------------------------------------

hl.bind(mod .. " + code:49", hl.dsp.focus({ workspace = "name:solitude" }))
hl.bind("ALT + code:49",     hl.dsp.window.move({ workspace = "name:solitude", follow = false }))

--------------------------------------------------------------------
-- Special workspace (scratchpad) - kept commented, as in the old config
--------------------------------------------------------------------

-- hl.bind(mod .. " + S",        hl.dsp.workspace.toggle_special())
-- hl.bind(v.modShift .. " + S", hl.dsp.window.move({ workspace = "special", follow = false }))
