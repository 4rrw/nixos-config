local h = require("hypr.helpers")

-- Focus with vim keys; arrow keys in tiling.lua.
h.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
h.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
h.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
h.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Swap with vim keys.
h.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
h.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
h.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
h.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

h.bind_launch("SUPER + RETURN", "Terminal", "ghostty")
h.bind_launch("SUPER + B", "Browser", "brave")
h.bind_launch("SUPER + SHIFT + B", "Browser (private)", "brave --incognito")
h.bind_launch("SUPER + E", "File manager", "nautilus")
h.bind_launch("SUPER + O", "Obsidian", "obsidian -disable-gpu --enable-wayland-ime")
h.bind_launch("SUPER + N", "Sessionizer", "ghostty -e tms")

-- Noctalia panels over IPC. Claims SUPER + S and ALT + TAB; tiling.lua leaves them free.
h.bind("SUPER + SPACE", "Launcher", "noctalia msg panel-toggle launcher")
h.bind("SUPER + S", "Control center", "noctalia msg panel-toggle control-center")
h.bind("SUPER + COMMA", "Settings", "noctalia msg settings-toggle")
h.bind("ALT + TAB", "Window switcher", "noctalia msg window-switcher")
h.bind("SUPER + ESCAPE", "Power menu", "noctalia msg panel-toggle session")

-- Capture. noctalia does the freeze, region overlay, save and clipboard copy
-- itself; satty is wired up as its pipe_command in config.toml.
h.bind("PRINT", "Screenshot", "noctalia msg screenshot-region")
h.bind("SHIFT + PRINT", "Screenshot (whole monitor)", "noctalia msg screenshot-fullscreen")
h.bind("SUPER + PRINT", "Colour picker", "pkill hyprpicker || hyprpicker -a")

-- Media keys. repeating = held-key repeats, locked = works on lock screen.
h.bind("XF86AudioRaiseVolume", "Volume up", "noctalia msg volume-up", { repeating = true, locked = true })
h.bind("XF86AudioLowerVolume", "Volume down", "noctalia msg volume-down", { repeating = true, locked = true })
h.bind("XF86AudioMute", "Mute", "noctalia msg volume-mute", { locked = true })
h.bind("XF86MonBrightnessUp", "Brightness up", "noctalia msg brightness-up", { repeating = true, locked = true })
h.bind("XF86MonBrightnessDown", "Brightness down", "noctalia msg brightness-down", { repeating = true, locked = true })
