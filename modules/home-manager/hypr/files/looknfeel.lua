local h = require("hypr.helpers")

if h.hostname() == "konkuter" then
	hl.config({
		general = {
			gaps_in = 8,
			gaps_out = { top = 300, right = 16, bottom = 200, left = 16 },
			border_size = 2,
			layout = "master",
		},

		master = {
			orientation = "center",
			slave_count_for_center_master = 0,
			always_keep_position = false,
			mfact = 0.6,
			new_status = "slave",
			new_on_top = true,
		},
	})
else
	hl.config({
		general = {
			gaps_in = 8,
			gaps_out = 16,
			border_size = 2,
			layout = "master",
		},
	})
end

hl.config({
	decoration = {
		rounding = 16,

		-- Must stay below 1 or decoration.blur has nothing to blur through.
		active_opacity = 0.90,
		inactive_opacity = 0.85,

		blur = {
			enabled = true,
			size = 8,
			new_optimizations = true,
		},
	},
})

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

hl.config({ animations = { enabled = true } })
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
