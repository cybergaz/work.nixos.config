-- Scrolling-layout controls.
-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- `hl.dsp.layout(...)` is the old `layoutmsg` dispatcher.

local v   = require("00-vars")
local mod = v.mod
local rep = { repeating = true }

hl.bind(mod .. " + F", hl.dsp.layout("colresize +conf"))

hl.bind(mod .. " + L",     hl.dsp.layout("focus r"), rep)
hl.bind(mod .. " + H",     hl.dsp.layout("focus l"), rep)
hl.bind(mod .. " + right", hl.dsp.layout("focus r"), rep)
hl.bind(mod .. " + left",  hl.dsp.layout("focus l"), rep)

hl.bind(v.modShift .. " + H", hl.dsp.layout("swapcol l"), rep)
hl.bind(v.modShift .. " + L", hl.dsp.layout("swapcol r"), rep)
