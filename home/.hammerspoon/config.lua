local M = {}

-- Apps to keep alive when switching modes (e.g. Spotify)
M.keepAlive = {
  "Spotify",
}

local presets = {
  ["standard"] = {
    name   = "Standard",
    spaces = { main = 3, secondary = 1 },
    layout = {
      { name = "Chrome", monitor = "main", space = 1, pos = "max", url = "https://app.notion.com/p/ozzzhang/INFO4990-CS-Research-Methods-3b98aa426b4a80e08e06dccaeb85541c" },
      { name = "Kitty", monitor = "main", space = 2, pos = "left" },
      { name = "Notability", monitor = "main", space = 2, pos = "right" },
      { name = "Day One", monitor = "main", space = 3, pos = "max" },
    },
  },
}

M.presets = presets

M.bindings = {
  { mods = {"cmd", "alt", "ctrl"}, key = "S", preset = presets["standard"] },
}

return M