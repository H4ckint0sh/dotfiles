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

-- Applications
-- Open or focus app
local function open_app(names)
	return function()
		for _, name in pairs(names) do
			if hs.application.launchOrFocus(name) then
				return
			end
		end
	end
end

-- Applications, toggle visibility
hs.hotkey.bind(shifopt, "T", open_app({ "kitty" }))                            -- Terminal
hs.hotkey.bind(shifopt, "S", open_app({ "Spotify" }))
hs.hotkey.bind(shifopt, "C", open_app({ "Microsoft Teams (work or school)" })) -- Contact
hs.hotkey.bind(shifopt, "M", open_app({ "Microsoft Outlook" }))                -- Mail
hs.hotkey.bind(shifopt, "B", open_app({ "Chromium" }))

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
