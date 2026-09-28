-- Window focus, state and geometry.

local v = require("00-vars")
local mod = v.mod

--------------------------------------------------------------------
-- Focus / cycling
--------------------------------------------------------------------

-- Both a cycle and a raise are bound to TAB, exactly as in the old config.
hl.bind(mod .. " + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind(mod .. " + Tab", hl.dsp.window.bring_to_top())
hl.bind(v.modShift .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(v.modShift .. " + Tab", hl.dsp.window.bring_to_top())

hl.bind(mod .. " + G", hl.dsp.focus({ last = true }))
hl.bind(mod .. " + semicolon", hl.dsp.focus({ last = true }))

hl.bind(mod .. " + H", hl.dsp.window.bring_to_top())
hl.bind(mod .. " + L", hl.dsp.window.bring_to_top())
hl.bind(v.modShift .. " + L", hl.dsp.window.bring_to_top())

--------------------------------------------------------------------
-- Window state
--------------------------------------------------------------------

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(v.modShift .. " + Q", hl.dsp.exit())

hl.bind(v.modShift .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + up", hl.dsp.window.fullscreen())
hl.bind(mod .. " + down", hl.dsp.window.fullscreen())

hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + X", hl.dsp.window.pin())

--------------------------------------------------------------------
-- Mouse drag / resize
--------------------------------------------------------------------

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { drag = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { drag = true })

--------------------------------------------------------------------
-- Resize the active window (old `binde ... resizeactive`)
--------------------------------------------------------------------

local rep = { repeating = true }

local resizes = {
    { key = "H", x = -30, y = 0 },
    { key = "L", x = 30, y = 0 },
    { key = "K", x = 0, y = -20 },
    { key = "J", x = 0, y = 20 },
    { key = "left", x = -20, y = 0 },
    { key = "right", x = 20, y = 0 },
    { key = "up", x = 0, y = -20 },
    { key = "down", x = 0, y = 20 },
}

for _, r in ipairs(resizes) do
    hl.bind(v.modAlt .. " + " .. r.key, hl.dsp.window.resize({ x = r.x, y = r.y, relative = true }), rep)
end

--------------------------------------------------------------------
-- Move the active window (old `movewindow` / `moveactive`)
--------------------------------------------------------------------

local directions = { H = "l", J = "d", K = "u", L = "r" }
for key, dir in pairs(directions) do
    hl.bind(v.modCtrl .. " + " .. key, hl.dsp.window.move({ direction = dir }))
end

local moves = {
    { key = "left", x = -20, y = 0 },
    { key = "right", x = 20, y = 0 },
    { key = "up", x = 0, y = -20 },
    { key = "down", x = 0, y = 20 },
}

for _, m in ipairs(moves) do
    hl.bind(v.modCtrl .. " + " .. m.key, hl.dsp.window.move({ x = m.x, y = m.y, relative = true }), rep)
end

--------------------------------------------------------------------
-- Numpad mouse emulation (ydotool)
--------------------------------------------------------------------

hl.bind("KP_Begin", hl.dsp.exec_cmd("ydotool click c0"))
hl.bind("SHIFT + KP_Begin", hl.dsp.exec_cmd("ydotool click 41"))

-- key -> {dx, dy} at the slow (10px) step; SHIFT gives the 50px step.
local mouseKeys = {
    KP_Left = { -1, 0 },
    KP_Right = { 1, 0 },
    KP_Up = { 0, -1 },
    KP_Down = { 0, 1 },
    KP_Home = { -1, -1 },
    KP_Prior = { 1, -1 },
    KP_End = { -1, 1 },
    KP_Next = { 1, 1 },
}

for key, d in pairs(mouseKeys) do
    hl.bind(key, hl.dsp.exec_cmd(("ydotool mousemove -x %d -y %d"):format(d[1] * 10, d[2] * 10)), rep)
    hl.bind("SHIFT + " .. key, hl.dsp.exec_cmd(("ydotool mousemove -x %d -y %d"):format(d[1] * 50, d[2] * 50)), rep)
end
