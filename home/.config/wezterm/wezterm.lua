local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- #config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE | TITLE"

config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 0.2,
  brightness = 0.4,
}

-- Dim unfocused windows so the focused one is obvious at a glance.
local UNFOCUSED_FOREGROUND_TEXT_HSB = { hue = 1.0, saturation = 0.25, brightness = 0.45 }
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

-- get_config_overrides() hands back a copy, so the current value is never the
-- same table we last stored; compare the fields instead of the identity.
local function same_text_hsb(actual, expected)
	if actual == nil or expected == nil then
		return actual == expected
	end
	return actual.hue == expected.hue
		and actual.saturation == expected.saturation
		and actual.brightness == expected.brightness
end

wezterm.on("window-focus-changed", function(window)
	local overrides = window:get_config_overrides() or {}
	local text_hsb, opacity
	if not window:is_focused() then
		text_hsb = UNFOCUSED_FOREGROUND_TEXT_HSB
		opacity = UNFOCUSED_WINDOW_BACKGROUND_OPACITY
	end

	-- Only write when one of the two values we own actually changes; a redundant
	-- set_config_overrides() call would trigger another config reload.
	if same_text_hsb(overrides.foreground_text_hsb, text_hsb) and overrides.window_background_opacity == opacity then
		return
	end

	overrides.foreground_text_hsb = text_hsb
	overrides.window_background_opacity = opacity
	window:set_config_overrides(overrides)
end)

wezterm.on('update-right-status', function(window, pane)
  
  -- Grab the current date and time
  -- %I:%M %p gives "01:34 PM", %a %b %-d gives "Mon Aug 10"
  local time = wezterm.strftime('%I:%M %p')
  local date = wezterm.strftime('%a %b %-d')

  -- Grab the active workspace name
  local workspace = window:active_workspace()

  -- Format the output with colors and set it as the right status
  window:set_right_status(wezterm.format({
    -- Workspace section
    { Foreground = { AnsiColor = 'Teal' } },
    { Text = ' Workspace: ' .. workspace .. '  |  ' },
    
    -- Date section
    { Foreground = { AnsiColor = 'Silver' } },
    { Text = date .. '  ' },
    
    -- Time section
    { Foreground = { AnsiColor = 'White' } },
    { Text = time .. ' ' },
  }))
end)

return config
