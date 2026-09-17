-- List monitors with: hyprctl monitors all
local h = require("hypr.helpers")

if h.hostname() == "konkuter" then
	-- LG C2 4K@120
	hl.env("GDK_SCALE", "1")
	hl.monitor({
		output = "HDMI-A-2",
		mode = "3840x2160@120",
		-- mode = "3840x1600@120",
		-- mode = "2560x1080@120",
		position = "auto",
		scale = 1.25,
		bitdepth = 10,
		cm = "auto",
		supports_hdr = 1,
		sdrbrightness = 1,
		vrr = 2,
	})

	-- Keeps XWayland/Proton games sharp instead of letting them render at the
	-- 1.25 scale and get upscaled.
	hl.config({ xwayland = { force_zero_scaling = true } })

	-- vrr 2 is fullscreen-only; always-on VRR flickers the brightness on amdgpu.
	-- direct_scanout lets a fullscreen game hand its buffer straight to the
	-- display, skipping composition -- `hyprctl monitors` names what is still in
	-- the way under directScanoutBlockedBy, which is what hypr-gaming turns off.
	-- (misc.vfr from the usual guides is gone in 0.55; it is debug.vfr now and
	-- already defaults to true.)
	hl.config({
		misc = { vrr = 2 },
		render = { direct_scanout = 1 },
	})
else
	-- Laptop panel.
	hl.env("GDK_SCALE", "1")
	hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end
