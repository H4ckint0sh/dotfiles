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

-- Function to get the app icon
local function getIconForApp(appName)
	return app_icons[appName] or "?"
end

-- Function to update workspace icons
local function updateSpaceIcons(spaceId, workspaceName)
	local icon_strip = ""
	local shouldDraw = false

	sbar.exec(LIST_APPS:format(workspaceName), function(appsOutput)
		if not appsOutput then
			return
		end

		for app in appsOutput:gmatch("[^\r\n]+") do
			local appName = app:match("^%s*(.-)%s*$")
			if appName and appName ~= "" then
				icon_strip = icon_strip .. " " .. getIconForApp(appName)
				shouldDraw = true
			end
		end

		-- Verify if the item exists before trying to update it
		if spaces[spaceId] then
			spaces[spaceId].item:set({
				label = { string = icon_strip, drawing = shouldDraw },
			})
		else
			print("Warning: Workspace '" .. spaceId .. "' not found to update icons.")
		end
	end)
end

-- Function to add a workspace item
local function addWorkspaceItem(workspaceName, monitorId, isSelected)
	local spaceId = "workspace_" .. workspaceName .. "_" .. monitorId

	if not spaces[spaceId] then
		local space_item = sbar.add("item", spaceId, {
			icon = {
				font = { family = settings.font.numbers },
				string = workspaceName,
				padding_left = 12,
				padding_right = 12,
				color = colors.white,
				highlight_color = colors.yellow,
			},
			label = {
				padding_right = 14,
				padding_left = 0,
				color = colors.grey,
				highlight_color = colors.yellow,
				font = "sketchybar-app-font:Regular:12.0",
				y_offset = -1,
			},
			padding_left = 2,
			padding_right = 2,
			background = {
				color = colors.bg1,
				border_width = 1,
				height = 26,
				border_color = colors.grey,
				corner_radius = 9,
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
				corner_radius = 9,
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
	end
end

local cachedMonitors = {}
local cachedWorkspaces = {}

-- Error Handling and Safe Execution
local function safeExec(command, callback)
	sbar.exec(command, function(output)
		if output then
			callback(output)
		end
	end)
end

-- Function to Get the List of Monitors
local function getMonitors(callback)
	safeExec(LIST_MONITORS, function(monitorsOutput)
		local monitorList = {}
		for monitorId in monitorsOutput:gmatch("[^\r\n]+") do
			table.insert(monitorList, monitorId)
		end
		callback(monitorList)
	end)
end

-- Function to Get the Currently Focused Workspace
local function getFocusedWorkspace(callback)
	safeExec(LIST_CURRENT, function(focusedWorkspaceOutput)
		local focusedWorkspace = focusedWorkspaceOutput:match("[^\r\n]+")
		callback(focusedWorkspace)
	end)
end

-- Function to Get and Sort Workspaces by Monitor
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

-- Function to Draw the Workspaces
local function drawWorkspaces(monitorList, focusedWorkspace)
	local updatedSpaces = {}

	for _, monitorId in ipairs(monitorList) do
		getWorkspacesForMonitor(monitorId, function(workspaces)
			cachedWorkspaces[monitorId] = workspaces

			for _, workspaceName in ipairs(workspaces) do
				local spaceId = "workspace_" .. workspaceName .. "_" .. monitorId
				local isSelected = workspaceName == focusedWorkspace
				addWorkspaceItem(workspaceName, monitorId, isSelected)
				updatedSpaces[spaceId] = true
			end
		end)
	end

	-- Remove obsolete workspaces
	for spaceId, _ in pairs(spaces) do
		if not updatedSpaces[spaceId] then
			removeWorkspaceItem(spaceId)
		end
	end
end

-- Cache System to Avoid Redundant Executions
local function isCacheValid(monitorList, focusedWorkspace)
	if #monitorList ~= #cachedMonitors then
		return false
	end

	for i, monitorId in ipairs(monitorList) do
		if monitorId ~= cachedMonitors[i] then
			return false
		end
		if cachedWorkspaces[monitorId] == nil then
			return false
		end
	end

	return focusedWorkspace == cachedWorkspaces.focusedWorkspace
end

-- Main Function to Draw the Spaces
local function drawSpaces()
	getMonitors(function(monitorList)
		getFocusedWorkspace(function(focusedWorkspace)
			if not isCacheValid(monitorList, focusedWorkspace) then
				drawWorkspaces(monitorList, focusedWorkspace)
				cachedMonitors = monitorList
				cachedWorkspaces.focusedWorkspace = focusedWorkspace
			end
		end)
	end)
end

drawSpaces()

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_window_observer:subscribe("aerospace_workspace_change", function()
	drawSpaces()
end)

space_window_observer:subscribe("front_app_switched", function()
	drawSpaces()
end)

space_window_observer:subscribe("space_windows_change", function()
	sbar.exec(LIST_CURRENT, function(focusedWorkspaceOutput)
		local focusedWorkspace = focusedWorkspaceOutput:match("[^\r\n]+")
		if focusedWorkspace then
			local monitorId = workspaceToMonitorMap[focusedWorkspace]
			if monitorId then
				-- print("Monitor: " .. monitorId)
				local spaceId = "workspace_" .. focusedWorkspace .. "_" .. monitorId
				-- print("id space: " .. spaceId)
				updateSpaceIcons(spaceId, focusedWorkspace)
				-- else
				-- 	print("Warning: MonitorId for workspace '" .. focusedWorkspace .. "' not found")
			end
		end
		-- Also update all workspaces if necessary
		drawSpaces()
	end)
end)

-- Indicator for swapping menus and spaces
local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(_)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 0.5 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(_)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(_)
	sbar.trigger("swap_menus_and_spaces")
end)
