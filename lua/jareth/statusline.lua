-- Access colors via galaxyline's recommended naming
-- E.g. `highlights.blue`, `highlights.yellow`
local status_ok, highlights = pcall(require, 'rose-pine.plugins.galaxyline')
if not status_ok then
    return
end

-- Check if the end user is using this fork with themes support
-- before trying to add the theme
local status_ok, galaxyline_colors = pcall(require, "galaxyline.themes.colors")
if not status_ok then
  return
end

galaxyline_colors['doom-one'] = highlights

require("galaxyline.themes.eviline")
