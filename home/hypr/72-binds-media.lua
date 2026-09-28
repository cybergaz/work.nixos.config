-- Brightness, audio and media keys.
-- `repeating = true` is the old `binde`; `locked = true` keeps them working
-- while the session is locked.

local rep = { repeating = true, locked = true }
local lock = { locked = true }

--------------------------------------------------------------------
-- Brightness
--------------------------------------------------------------------

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), rep)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), rep)
hl.bind("SHIFT + F2",            hl.dsp.exec_cmd("brightnessctl set 2"))
hl.bind("SHIFT + F3",            hl.dsp.exec_cmd("brightnessctl set 100%"))

--------------------------------------------------------------------
-- Volume
--------------------------------------------------------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), rep)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"), rep)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), lock)

hl.bind("SHIFT + F8", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 100%"))
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%"))

-- mic mute, if you ever want it:
-- hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), lock)

--------------------------------------------------------------------
-- Playback
--------------------------------------------------------------------

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), lock)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),       lock)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),   lock)
