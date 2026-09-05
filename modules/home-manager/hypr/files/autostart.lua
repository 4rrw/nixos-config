local h = require("hypr.helpers")

hl.on("hyprland.start", function()
  hl.exec_cmd(h.launch("noctalia"))
end)

-- Applies the profiles in hyprsunset.conf.
hl.on("hyprland.start", function()
  hl.exec_cmd(h.launch("hyprsunset"))
end)

if h.hostname() == "konkuter" then
  -- Randomize outer gaps on startup to prevent OLED burn-in.
  hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/bin/hyprland-randomize-gaps.sh")
  end)
end
