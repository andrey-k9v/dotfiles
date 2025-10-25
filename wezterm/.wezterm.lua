-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()
local workspace_home = wezterm.home_dir .. "/workspace/"
local function workspace_configs()
	local workspace_configs = {
		{ id = "home", label = "home", cwd = workspace_home },
	}

	return workspace_configs
end

local function workspace_selector_choices()
	local choices = {}
	for _, value in ipairs(workspace_configs()) do
		table.insert(choices, { id = value.id, label = value.label })
	end
	return choices
end

local function get_workspace_by_id(id)
	for _, value in ipairs(workspace_configs()) do
		if value.id == id then
			return value
		end
	end
end

local function choose_workspace()
	return wezterm.action.InputSelector({
		title = "Workspaces",
		choices = workspace_selector_choices(),
		fuzzy = true,
		action = wezterm.action_callback(function(child_window, child_pane, id, label)
			child_window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = label,
					spawn = {
						cwd = get_workspace_by_id(id).cwd,
					},
				}),
				child_pane
			)
		end),
	})
end

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- splitting
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "=",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- rotate panes
	{
		mods = "LEADER",
		key = "Space",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		mods = "LEADER",
		key = "0",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "H", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "`", mods = "LEADER", action = wezterm.action.ActivateLastTab },
	{ key = " ", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

	-- Activate Copy Mode
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	-- Paste from Copy Mode
	{ key = "]", mods = "LEADER", action = wezterm.action.PasteFrom("PrimarySelection") },
	{
		key = "'",
		mods = "LEADER",
		action = choose_workspace(),
	},
	{
		key = "f",
		mods = "LEADER",
		-- Present a list of existing workspaces
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
}

config.key_tables = {
	-- added new shortcuts to the end
	copy_mode = {
		{ key = "c", mods = "CTRL", action = wezterm.action.CopyMode("Close") },
		{ key = "g", mods = "CTRL", action = wezterm.action.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = wezterm.action.CopyMode("Close") },
		{ key = "Escape", mods = "NONE", action = wezterm.action.CopyMode("Close") },

		{ key = "h", mods = "NONE", action = wezterm.action.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = wezterm.action.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = wezterm.action.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = wezterm.action.CopyMode("MoveRight") },

		{ key = "LeftArrow", mods = "NONE", action = wezterm.action.CopyMode("MoveLeft") },
		{ key = "DownArrow", mods = "NONE", action = wezterm.action.CopyMode("MoveDown") },
		{ key = "UpArrow", mods = "NONE", action = wezterm.action.CopyMode("MoveUp") },
		{ key = "RightArrow", mods = "NONE", action = wezterm.action.CopyMode("MoveRight") },

		{ key = "RightArrow", mods = "ALT", action = wezterm.action.CopyMode("MoveForwardWord") },
		{ key = "f", mods = "ALT", action = wezterm.action.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },
		{ key = "w", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },

		{ key = "LeftArrow", mods = "ALT", action = wezterm.action.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "ALT", action = wezterm.action.CopyMode("MoveBackwardWord") },
		{ key = "Tab", mods = "SHIFT", action = wezterm.action.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "NONE", action = wezterm.action.CopyMode("MoveBackwardWord") },

		{ key = "0", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLine") },
		{ key = "Enter", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfNextLine") },

		{ key = "$", mods = "NONE", action = wezterm.action.CopyMode("MoveToEndOfLineContent") },
		{ key = "$", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToEndOfLineContent") },
		{ key = "^", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLineContent") },
		{ key = "^", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToStartOfLineContent") },
		{ key = "m", mods = "ALT", action = wezterm.action.CopyMode("MoveToStartOfLineContent") },

		{ key = " ", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "V", mods = "SHIFT", action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = wezterm.action.CopyMode({ SetSelectionMode = "Block" }) },

		{ key = "G", mods = "NONE", action = wezterm.action.CopyMode("MoveToScrollbackBottom") },
		{ key = "G", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToScrollbackBottom") },
		{ key = "g", mods = "NONE", action = wezterm.action.CopyMode("MoveToScrollbackTop") },

		{ key = "H", mods = "NONE", action = wezterm.action.CopyMode("MoveToViewportTop") },
		{ key = "H", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToViewportTop") },
		{ key = "M", mods = "NONE", action = wezterm.action.CopyMode("MoveToViewportMiddle") },
		{ key = "M", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToViewportMiddle") },
		{ key = "L", mods = "NONE", action = wezterm.action.CopyMode("MoveToViewportBottom") },
		{ key = "L", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToViewportBottom") },

		{ key = "o", mods = "NONE", action = wezterm.action.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "O", mods = "NONE", action = wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "O", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz") },

		{ key = "PageUp", mods = "NONE", action = wezterm.action.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = wezterm.action.CopyMode("PageDown") },

		{ key = "b", mods = "CTRL", action = wezterm.action.CopyMode("PageUp") },
		{ key = "f", mods = "CTRL", action = wezterm.action.CopyMode("PageDown") },

		-- Enter y to copy and quit the copy mode.
		{
			key = "y",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
				wezterm.action.CopyMode("Close"),
			}),
		},
		-- Enter search mode to edit the pattern.
		-- When the search pattern is an empty string the existing pattern is preserved
		{ key = "/", mods = "NONE", action = wezterm.action({ Search = { CaseSensitiveString = "" } }) },
		{ key = "?", mods = "NONE", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
		{ key = "n", mods = "CTRL", action = wezterm.action({ CopyMode = "NextMatch" }) },
		{ key = "p", mods = "CTRL", action = wezterm.action({ CopyMode = "PriorMatch" }) },
	},

	search_mode = {
		{ key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
		-- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
		-- to navigate search results without conflicting with typing into the search area.
		{ key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
		{ key = "c", mods = "CTRL", action = "ActivateCopyMode" },
		{ key = "n", mods = "CTRL", action = wezterm.action({ CopyMode = "NextMatch" }) },
		{ key = "p", mods = "CTRL", action = wezterm.action({ CopyMode = "PriorMatch" }) },
		{ key = "r", mods = "CTRL", action = wezterm.action.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = wezterm.action.CopyMode("ClearPattern") },
	},
}
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Tokyo Night Storm"
config.initial_rows = 45
config.initial_cols = 150
config.font_size = 16

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.window_background_opacity = 1.0

config.macos_window_background_blur = 15

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end

	local tab, editor_pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
