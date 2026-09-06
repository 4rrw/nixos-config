-- Second and third window on a workspace open to the right.
hl.workspace_rule({ workspace = "w[tv2-3]", layout_opts = { orientation = "right" } })

-- Noctalia's settings window is a regular window, not layer-shell; float it.
hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})
--
-- Blur through noctalia's layer-shell surfaces.
hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
	},
	no_anim = true,
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

-- Satty opens on every screenshot via noctalia's pipe_command,
hl.window_rule({
	match = { class = "com.gabm.satty" },
	float = true,
	center = true,
	opaque = true,
})

-- Image viewer. Opaque because decoration.active_opacity would otherwise let the
-- windows behind it show through whatever you are looking at.
hl.window_rule({
	match = { class = "org.gnome.Loupe" },
	float = true,
	center = true,
	opaque = true,
})
