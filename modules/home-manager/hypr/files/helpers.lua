local M = {}

-- Own systemd scope, not a child of the compositor. Needs programs.hyprland.withUWSM.
function M.launch(command)
  return "uwsm-app -- " .. command
end

-- hl.bind with a positional description; a string is treated as a command.
function M.bind(keys, description, dispatcher, options)
  local opts = options or {}
  opts.description = description

  if type(dispatcher) == "string" then
    dispatcher = hl.dsp.exec_cmd(dispatcher)
  end

  hl.bind(keys, dispatcher, opts)
end

function M.bind_launch(keys, description, command, options)
  M.bind(keys, description, M.launch(command), options)
end

-- Hostname, for the per-host branches in monitors/looknfeel/autostart.
-- /etc/hostname rather than os.getenv("HOSTNAME"), which hyprland does not set.
function M.hostname()
  local f = io.open("/etc/hostname")
  if not f then
    return ""
  end
  local name = f:read("*l")
  f:close()
  return name
end

-- hl.window_rule; a bare string is shorthand for class.
function M.window(match, rules)
  rules.match = rules.match or {}

  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end

  hl.window_rule(rules)
end

return M
