local h = require("hypr.helpers")

-- Absolute path: hyprland does not inherit the PATH fish builds, so ~/bin is
-- not on it.
local screenshot = os.getenv("HOME") .. "/bin/screenshot.sh"

h.bind("PRINT", "Screenshot", screenshot)
h.bind("SHIFT + PRINT", "Screenshot (whole monitor)", screenshot .. " fullscreen")
h.bind("SUPER + ALT + PRINT", "Annotate last screenshot", screenshot .. " edit")
h.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")

-- Satty is a transient editor, not something to tile into the workspace. Size
-- has to be integer pixels: hyprland's config accepts "70%" here but the lua
-- rule API does not, and a percentage silently leaves the window full-screen.
h.window("com.gabm.satty", {
  float = true,
  size = h.hostname() == "konkuter" and { 2100, 1300 } or { 1500, 900 },
  center = true,
})
