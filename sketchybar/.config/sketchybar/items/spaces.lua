local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Commands to get information about monitors and workspaces
local LIST_MONITORS = "aerospace list-monitors | awk '{print $1}'"
local LIST_WORKSPACES = "aerospace list-workspaces --monitor %s"
local LIST_APPS = "aerospace list-windows --workspace %s | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'"
local LIST_CURRENT = "aerospace list-workspaces --focused"

local spaces = {}
local workspaceToMonitorMap = {}

-- Cache para íconos de aplicaciones para evitar búsquedas repetitivas
local icon_cache = {}

-- Function to get the icon for an application
local function getIconForApp(appName)
	if icon_cache[appName] then
		return icon_cache[appName]
	end
	local icon = app_icons[appName] or app_icons["default"] or "?"
	icon_cache[appName] = icon
	return icon
	--return app_icons[appName] or app_icons["default"] or "?"
end

-- Function to update workspace icons
local function updateSpaceIcons(spaceId, workspaceName)
	sbar.exec(LIST_APPS:format(workspaceName), function(appsOutput)
		if not appsOutput then
			return
		end

		local icon_strip = ""
		local shouldDraw = false

		for app in appsOutput:gmatch("[^\r\n]+") do
			local appName = app:match("^%s*(.-)%s*$")
			if appName and appName ~= "" then
				icon_strip = icon_strip .. " " .. getIconForApp(appName)
				shouldDraw = true
			end
		end

		if spaces[spaceId] then
			spaces[spaceId].item:set({
				label = { string = icon_strip, drawing = shouldDraw },
			})
		else
		end
	end)
end

-- Function to add or update a workspace item
local function addOrUpdateWorkspaceItem(workspaceName, monitorId, isSelected)
	local spaceId = "workspace_" .. workspaceName .. "_" .. monitorId

	if not spaces[spaceId] then
		local space_item = sbar.add("item", spaceId, {
			icon = {
				font = { family = settings.font.numbers },
				string = workspaceName,
				padding_left = 12,
				padding_right = 12,
				color = colors.grey,
				highlight_color = colors.white,
			},
			label = {
				padding_right = 12,
				padding_left = 0,
				color = colors.grey,
				highlight_color = colors.white,
				font = "sketchybar-app-font:Regular:12.0",
				y_offset = -1,
			},
			padding_left = 2,
			padding_right = 2,
			background = {
				color = colors.bg2,
				border_width = 1,
				height = 24,
				corner_radius = 7,
			},
			click_script = "aerospace workspace " .. workspaceName,
			display = monitorId,
		})

		local space_bracket = sbar.add("bracket", { spaceId }, {
			background = {
				color = colors.transparent,
				border_color = colors.transparent,
				height = 26,
				border_width = 1,
				corner_radius = 7,
			},
		})

		space_item:subscribe("mouse.clicked", function()
			sbar.exec("aerospace workspace " .. workspaceName)
		end)

		spaces[spaceId] = { item = space_item, bracket = space_bracket }
		workspaceToMonitorMap[workspaceName] = monitorId
	end

	spaces[spaceId].item:set({
		icon = { highlight = isSelected },
		label = { highlight = isSelected },
	})
	spaces[spaceId].bracket:set({
		background = { border_color = isSelected and colors.dirty_white or colors.transparent },
	})

	updateSpaceIcons(spaceId, workspaceName)
end

-- Function to remove a workspace item
local function removeWorkspaceItem(spaceId)
	if spaces[spaceId] then
		sbar.remove(spaces[spaceId].item)
		sbar.remove(spaces[spaceId].bracket)
		spaces[spaceId] = nil

		local workspaceName = spaceId:match("workspace_(.-)_%d+")
		if workspaceName then
			workspaceToMonitorMap[workspaceName] = nil
		end
	else
	end
end

-- Safe execution function
local function safeExec(command, callback)
	sbar.exec(command, function(output)
		if output then
			callback(output)
		end
	end)
end

-- Function to get the list of monitors
local function getMonitors(callback)
	safeExec(LIST_MONITORS, function(monitorsOutput)
		local monitors = {}
		for monitor in monitorsOutput:gmatch("[^\r\n]+") do
			table.insert(monitors, monitor)
		end
		callback(monitors)
	end)
end

-- Function to get the focused workspace
local function getFocusedWorkspace(callback)
	safeExec(LIST_CURRENT, function(focusedWorkspaceOutput)
		local focusedWorkspace = focusedWorkspaceOutput:match("[^\r\n]+")
		callback(focusedWorkspace)
	end)
end

-- Function to get and sort workspaces by monitor
local function getWorkspacesForMonitor(monitorId, callback)
	safeExec(LIST_WORKSPACES:format(monitorId), function(workspacesOutput)
		local workspaces = {}
		for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
			table.insert(workspaces, workspaceName)
		end
		table.sort(workspaces, function(a, b)
			return a:lower() < b:lower()
		end)
		callback(workspaces)
	end)
end

-- Function to update all workspaces
local function updateAllWorkspaces()
	getMonitors(function(monitorList)
		getFocusedWorkspace(function(focusedWorkspace)
			local updatedSpaces = {} -- Guarda todos los worskpaces independiente de los monitores
			for _, monitorId in ipairs(monitorList) do
				getWorkspacesForMonitor(monitorId, function(workspaces)
					for _, workspaceName in ipairs(workspaces) do
						local spaceId = "workspace_" .. workspaceName .. "_" .. monitorId
						local isSelected = workspaceName == focusedWorkspace
						addOrUpdateWorkspaceItem(workspaceName, monitorId, isSelected)
						updatedSpaces[spaceId] = true
					end

					-- Remove obsolete workspaces for this monitor
					for spaceId in pairs(spaces) do
						if not updatedSpaces[spaceId] and spaceId:match("_%d+$") == "_" .. monitorId then
							removeWorkspaceItem(spaceId)
						end
					end
				end)
			end
		end)
	end)
end

-- Initial setup
updateAllWorkspaces()

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_window_observer:subscribe(
	{ "aerospace_workspace_change", "front_app_switched", "space_windows_change" },
	function()
		updateAllWorkspaces()
	end
)

-- Indicator for swapping menus and spaces
local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 10,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.off,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.grey,
	},
	background = {
		color = colors.with_alpha(colors.bg2, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

local function toggleSpacesIndicator(currently_on)
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end

spaces_indicator:subscribe("swap_menus_and_spaces", function()
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	toggleSpacesIndicator(currently_on)
end)

local function animateSpacesIndicator(entered)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = entered and 1.0 or 0.0 },
				border_color = { alpha = entered and 0.5 or 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = entered and "dynamic" or 0 },
		})
	end)
end

spaces_indicator:subscribe("mouse.entered", function()
	animateSpacesIndicator(true)
end)
spaces_indicator:subscribe("mouse.exited", function()
	animateSpacesIndicator(false)
end)
spaces_indicator:subscribe("mouse.clicked", function()
	sbar.trigger("swap_menus_and_spaces")
end)
