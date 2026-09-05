local home = os.getenv("HOME")

-- Guarded: hyprctl reload re-runs this file in the same Lua state, and an
-- unguarded prepend would grow package.path without bound.
local config_path = home .. "/.config/?.lua"
if not package.path:find(config_path, 1, true) then
  package.path = config_path .. ";" .. package.path
end

-- require() caches, so on reload our modules would be skipped and edits would
-- not take. Collect before deleting rather than mutating mid-traversal.
local stale = {}
for module in pairs(package.loaded) do
  if module == "hypr" or module:sub(1, 5) == "hypr." then
    table.insert(stale, module)
  end
end
for _, module in ipairs(stale) do
  package.loaded[module] = nil
end

require("hypr.looknfeel")
require("hypr.monitors")
require("hypr.input")
require("hypr.tiling")
require("hypr.bindings")
require("hypr.windows")
require("hypr.autostart")

require("noctalia").apply_theme()
