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
-- local hyper = { "⌘", "⌥", "⌃", "⇧" }
local shifopt = { "⌥", "⇧" }

-- Convenience method to create and start an eventTap then store it in a global variable so it doesn't get garbage collected
MyEventTaps = {} -- global
function createEventTap(types, handler)
	table.insert(MyEventTaps, hs.eventtap.new(types, handler):start())
end

-- The Hammer key
-- Install com.stevekehlet.RemapCapsLockToF18.plist (see the README) to map Caps Lock to F18.
-- Hammer = hs.hotkey.modal.new()

-- function Hammer:entered()
-- logger.i("Hammer down")
-- self.isDown = true
-- end

-- function Hammer:exited()
-- logger.i("Hammer up")
-- self.isDown = false
-- end

-- Capture presses and releases of F18 to activate the hammer
-- createEventTap({
-- hs.eventtap.event.types.keyDown,
-- hs.eventtap.event.types.keyUp
-- }, function(event)
-- logger.i('caught key: ' .. event:getKeyCode() .. ' of type: ' .. event:getType())
-- 	if event:getKeyCode() == hs.keycodes.map['F18'] then
-- 		local isRepeat = event:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat)
-- 		if isRepeat > 0 then
-- 			return true -- ignore and discard
-- 		end
-- 		if event:getType() == hs.eventtap.event.types.keyDown then
-- 			Hammer:enter()
-- 			return true
-- 		else
-- 			Hammer:exit()
-- 			hs.eventtap.keyStroke({}, 'ESCAPE')
-- 			return true
-- 		end
-- 	end
-- end)

-- -- Applications
-- -- Open or focus app
local toggleApp = function(appName, launch)
	launch = launch or false
	local app = hs.application.get(appName)
	if app then
		if app:isFrontmost() then
			return
		else
			app:activate()
		end
	else
		if launch then
			hs.application.launchOrFocus(appName)
		else
			hs.alert.show("App '" .. appName .. "' is not loaded!")
		end
	end
end

hs.hotkey.bind(shifopt, "T", function() toggleApp("Wezterm", true) end)
hs.hotkey.bind(shifopt, "B", function() toggleApp("Chromium", true) end)
hs.hotkey.bind(shifopt, "S", function() toggleApp("spotify", true) end)
hs.hotkey.bind(shifopt, "C", function() toggleApp("Microsoft Teams (work or school)", true) end)
hs.hotkey.bind(shifopt, "M", function() toggleApp("Microsoft Outlook", true) end)
hs.hotkey.bind(shifopt, "E", function() toggleApp("zed", true) end)

-- caffeinate Icons
local ampOnIcon = [[ASCII:
.....1a..........AC..........E
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
.....5c.......................
]]

local ampOffIcon = [[ASCII:
.....1a.....x....AC.y.......zE
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
...x.5c....y.......z..........
]]

-- caffeine replacement
local caffeine = hs.menubar.new()

local function setCaffeineDisplay(state)
	if state then
		caffeine:setIcon(ampOnIcon)
	else
		caffeine:setIcon(ampOffIcon)
	end
end

local function caffeineClicked()
	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
	caffeine:setClickCallback(caffeineClicked)
	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Spotify shortcuts
-- Hammer:bind({}, 'p', hs.spotify.playpause)
-- Hammer:bind({}, 'right', hs.spotify.next)
-- Hammer:bind({}, 'left', hs.spotify.previous)
