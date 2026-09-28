-- Application launchers, menus, scripts and screenshots.

local v = require("00-vars")
local mod = v.mod

--------------------------------------------------------------------
-- Applications
--------------------------------------------------------------------

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(v.terminal))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(v.termFloat))
hl.bind(v.modShift .. " + Return", hl.dsp.exec_cmd(v.termFloat))

hl.bind(mod .. " + E", hl.dsp.exec_cmd("nemo --geometry=1160x630 ~/Downloads"))
hl.bind(v.modShift .. " + E", hl.dsp.exec_cmd("nemo --geometry=1160x630 " .. v.home .. "/workspace"))

hl.bind(mod .. " + W", hl.dsp.exec_cmd(v.browser))
hl.bind(v.modShift .. " + W", hl.dsp.exec_cmd(v.browser .. " --private-window"))

hl.bind(mod .. " + N", hl.dsp.exec_cmd("pkill wlctl || alacritty -t alacritty_float -e wlctl"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("pkill btop || alacritty -t btop -e btop --force-utf"))

hl.bind(v.modShift .. " + C", hl.dsp.exec_cmd([[hyprpicker | wl-copy -n && notify-send "Hyprpicker" "$(wl-paste)"]]))

--------------------------------------------------------------------
-- wofi / menus / runners
--------------------------------------------------------------------

hl.bind(mod .. " + period", hl.dsp.exec_cmd("pkill wofi || ~/scripts/wofi/emoji.wofi.sh"))
hl.bind(
    mod .. " + space",
    hl.dsp.exec_cmd("pkill wofi || wofi --conf ~/.config/wofi/config -s ~/.config/wofi/style.css --normal-window")
)
hl.bind(mod .. " + I", hl.dsp.exec_cmd("pkill wofi || " .. v.home .. "/scripts/wofi/clipboard.wofi.sh"))
hl.bind(mod .. " + P", hl.dsp.exec_cmd(v.home .. "/scripts/wofi/logout.wofi.sh"))

--------------------------------------------------------------------
-- Scripts / one-liners
--------------------------------------------------------------------

hl.bind(mod .. " + B", hl.dsp.exec_cmd("pkill bluetui || alacritty -t alacritty_float -e bluetui"))
hl.bind(
    v.modAlt .. " + B",
    hl.dsp.exec_cmd([[bluetoothctl disconnect && notify-send ". . : :  Bluetooth  : : . ." " Disconnected "]])
)
hl.bind(
    v.modCtrl .. " + B",
    hl.dsp.exec_cmd(
        [[notify-send "Bluetooth Battery" "$(bluetoothctl info | grep 'Name:' | cut -b 8-)   ->   $(bluetoothctl info | grep 'Battery' | sed 's/.*(\([0-9]\+\))/\1/') % "]]
    )
)

-- hl.bind(mod .. " + M", hl.dsp.exec_cmd(v.home .. "/scripts/hyprland/touchpad_toggle.sh"))
-- hl.bind(mod .. " + comma", hl.dsp.exec_cmd(v.home .. "/scripts/hyprland/lid_sleep.sh"))
-- hl.bind(mod .. " + Z", hl.dsp.exec_cmd(v.home .. "/scripts/hyprland/toggle_opaque.sh"))

-- yank and append the previous clipboard entry to the current one
hl.bind(
    v.modShift .. " + Y",
    hl.dsp.exec_cmd([[echo -e "$(cliphist decode $(cliphist list | head -2 | tail -n 1))\n\n$(wl-paste)" | wl-copy]])
)

--------------------------------------------------------------------
-- Screenshots (needs ~/Pictures/Screenshots to exist)
--------------------------------------------------------------------

hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        [[pkill slurp || temp_ss_path=$HOME/Pictures/Screenshots/$(date +'%s.png') && grim -g "$(slurp)" $temp_ss_path && cat $temp_ss_path | wl-copy && notify-send "partial screenshot" "copied to clipboard"]]
    )
)
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("pkill slurp || ~/scripts/satty_screenshot.sh"))
hl.bind(
    mod .. " + Print",
    hl.dsp.exec_cmd(
        [[temp_ss_path=$HOME/Pictures/Screenshots/$(date +'%s.png') && grim $temp_ss_path && cat $temp_ss_path | wl-copy && notify-send "full screenshot" "copied to clipboard"]]
    )
)

--------------------------------------------------------------------
-- OCR / TTS
--------------------------------------------------------------------

local ocr =
    [[pkill slurp || grim -g "$(slurp)" /tmp/tesseract_temp.png && tesseract /tmp/tesseract_temp.png /tmp/tesseract_temp_output -l eng && cat /tmp/tesseract_temp_output.txt | wl-copy]]
local tts =
    [[wl-paste | piper-tts --model $HOME/.local/en_US-hfc_female-medium.onnx --output_file /tmp/temp_piper_audio.wav && notify-send "Playing" "selected entry from clipboard" && mpv /tmp/temp_piper_audio.wav]]

-- hl.bind(mod .. " + O",        hl.dsp.exec_cmd(ocr .. [[ && notify-send "Tesseract" ".  successfully copied to clipboard  ."]]))
hl.bind(v.modShift .. " + P", hl.dsp.exec_cmd(tts))
hl.bind(
    v.modShift .. " + O",
    hl.dsp.exec_cmd(ocr .. [[ && notify-send "OCR to TTS" ".  processing please wait  ." && ]] .. tts)
)
