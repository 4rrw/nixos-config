local h = require("hypr.helpers")

hl.on("hyprland.start", function()
  hl.exec_cmd(h.launch("noctalia"))
end)

-- Runs the SSH agent socket SSH_AUTH_SOCK points at, so ssh does not work until
-- it is up. There is no --hidden flag; start-to-tray is a setting inside the app.
hl.on("hyprland.start", function()
  hl.exec_cmd(h.launch("bitwarden"))
end)

-- Renders the password prompt for anything needing polkit auth. Without it
-- polkitd runs but GUI authentication just silently fails.
hl.on("hyprland.start", function()
  hl.exec_cmd(h.launch("hyprpolkitagent"))
end)

-- Locks and blanks on idle, per hypridle.conf.
hl.on("hyprland.start", function()
  hl.exec_cmd(h.launch("hypridle"))
end)

if h.hostname() == "konkuter" then
  -- Randomize outer gaps on startup to prevent OLED burn-in.
  hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/bin/hyprland-randomize-gaps.sh")
  end)
end
