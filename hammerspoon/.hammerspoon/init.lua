-- Reload config on file saves
function ReloadConfig(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", ReloadConfig):start()
hs.alert("Hammerspoon config reloaded")

-- Modifier shortcuts
local hyper = { "⌘", "⌥", "⌃", "⇧" }
local shifopt = { "⌥", "⇧" }

-- F19 and Hyperkey Hack
-- Keys you want to use with hyper key go here:
local hyperBindings = { 't', 'o', 'c', 'f', 'e', 'v', 'c', 'b', 'p', '\\', 'j', 'k', 'h', 'l', 'q', 'TAB' }

local k = hs.hotkey.modal.new({}, "F17")

---@diagnostic disable-next-line: unused-local
for i, key in ipairs(hyperBindings) do
	k:bind({}, key, nil, function()
		hs.eventtap.keyStroke(hyper, key)
		k.triggered = true
	end)
end

local pressedF18 = function()
	k.triggered = false
	k:enter()
end

local releasedF18 = function()
	k:exit()
	if not k.triggered then
		hs.eventtap.keyStroke({}, 'ESCAPE')
	end
end

---@diagnostic disable-next-line: unused-local
local f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Applications
-- Toggle named app's visibility, launching if needed
local function toggle_app(name)
	local focused = hs.window.focusedWindow()
	if focused then
		local app = focused:application()
		if app:title() == name then
			app:hide()
			return
		end
	end

	hs.application.launchOrFocus(name)
end

-- Applications, toggle visibility
hs.hotkey.bind(shifopt, 'b', function() toggle_app('Floorp') end)
hs.hotkey.bind(shifopt, 'c', function() toggle_app('Microsoft Teams (work or school)') end)
hs.hotkey.bind(shifopt, 'o', function() toggle_app('Microsoft Outlook') end)
hs.hotkey.bind(shifopt, 't', function() toggle_app('Wezterm') end)
hs.hotkey.bind(shifopt, 'f', function() toggle_app('Finder') end)
