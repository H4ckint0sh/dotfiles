local constants = require("constants")
local settings = require("config.settings")
local app_icons = require("config.icons").apps

local spaces = {}

local swapWatcher = sbar.add("item", {
	drawing = false,
	updates = true,
})

local currentWorkspaceWatcher = sbar.add("item", {
	drawing = false,
	updates = true,
})

local function selectCurrentWorkspace(focusedWorkspaceName)
	for sid, item in pairs(spaces) do
		if item ~= nil then
			local isSelected = sid == constants.items.SPACES .. "." .. focusedWorkspaceName
			item:set({
				icon = { color = isSelected and settings.colors.bg1 or settings.colors.white },
				label = { color = isSelected and settings.colors.bg1 or settings.colors.white },
				background = { color = isSelected and settings.colors.white or settings.colors.bg1 },
			})
		end
	end

	sbar.trigger(constants.events.UPDATE_WINDOWS)
end

local function findAndSelectCurrentWorkspace()
	sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(focusedWorkspaceOutput)
		local focusedWorkspaceName = focusedWorkspaceOutput:match("[^\r\n]+")
		selectCurrentWorkspace(focusedWorkspaceName)
	end)
end

local function addWorkspaceItem(workspaceName)
	local spaceName = constants.items.SPACES .. "." .. workspaceName

	spaces[spaceName] = sbar.add("item", spaceName, {
		icon = {
			string = workspaceName,
			padding_left = 15,
			padding_right = 0,
		},
		label = {
			padding_right = 15,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = settings.colors.bg1,
			border_width = 1,
			height = 26,
			border_color = settings.colors.black,
		},
		click_script = "aerospace workspace " .. workspaceName,
	})

	local function update()
		sbar.exec(constants.aerospace.GET_CURRENT_WINDOW_APPS(workspaceName), function(windowApps)
			local icon_line = ""
			local no_app = true

			-- Split the windowApps string into individual app names by lines
			for app in windowApps:gmatch("[^\r\n]+") do
				no_app = false
				local lookup = app_icons[app]
				-- Use the default icon if no match is found
				local icon = (lookup == nil) and app_icons["default"] or lookup
				-- Concatenate the app icons with a space
				icon_line = icon_line .. " " .. icon
			end

			-- If no apps are found, display a placeholder
			if no_app then
				icon_line = " —"
			end

			-- Update the SketchyBar label with the icons string
			spaces[spaceName]:set({ label = icon_line })
		end)
	end

	spaces[spaceName]:subscribe(constants.events.UPDATE_WINDOWS, update)
	spaces[spaceName]:subscribe(constants.events.FRONT_APP_SWITCHED, update)

	spaces[spaceName]:subscribe(constants.events.FRONT_APP_SWITCHED, function()
		sbar.exec(constants.aerospace.GET_CURRENT_WINDOW_APPS(workspaceName), function(windowApps)
			local icon_line = ""
			local no_app = true

			-- Split the windowApps string into individual app names by lines
			for app in windowApps:gmatch("[^\r\n]+") do
				no_app = false
				local lookup = app_icons[app]
				-- Use the default icon if no match is found
				local icon = (lookup == nil) and app_icons["default"] or lookup
				-- Concatenate the app icons with a space
				icon_line = icon_line .. " " .. icon
			end

			-- If no apps are found, display a placeholder
			if no_app then
				icon_line = " —"
			end

			-- Update the SketchyBar label with the icons string
			spaces[spaceName]:set({ label = icon_line })
		end)
	end)

	sbar.add("item", spaceName .. ".padding", {
		width = settings.dimens.padding.label,
	})
end

local function createWorkspaces()
	sbar.exec(constants.aerospace.LIST_ALL_WORKSPACES, function(workspacesOutput)
		for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
			addWorkspaceItem(workspaceName)
		end

		findAndSelectCurrentWorkspace()
	end)
end

swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
	local isShowingSpaces = env.isShowingMenu == "off" and true or false
	sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
end)

currentWorkspaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
	selectCurrentWorkspace(env.FOCUSED_WORKSPACE)
	sbar.trigger(constants.events.UPDATE_WINDOWS)
end)

createWorkspaces()
