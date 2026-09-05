-- List monitors with: hyprctl monitors all
local h = require("hypr.helpers")

if h.hostname() == "konkuter" then
  -- LG C2 4K@120
  hl.env("GDK_SCALE", "1.25")
  hl.monitor({
    output = "HDMI-A-2",
    mode = "3840x2160@120",
    position = "auto",
    scale = 1.25,
    bitdepth = 8,
    cm = "auto",
  })
else
  -- Laptop panel.
  hl.env("GDK_SCALE", "1")
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end
