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
local hyperBindings = { "a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"`",
	"=",
	"-",
	"]",
	"[",
	"\'",
	";",
	"\\",
	",",
	"/",
	".",
	"§",
	"f1",
	"f2",
	"f3",
	"f4",
	"f5",
	"f6",
	"f7",
	"f8",
	"f9",
	"f10",
	"f11",
	"f12",
	"pad.",
	"pad*",
	"pad+",
	"pad/",
	"pad-",
	"pad=",
	"pad0",
	"pad1",
	"pad2",
	"pad3",
	"pad4",
	"pad5",
	"pad6",
	"pad7",
	"pad8",
	"pad9",
	"padclear",
	"padenter",
	"return",
	"tab",
	"space",
	"delete",
	"help",
	"home",
	"pageup",
	"forwarddelete",
	"end",
	"pagedown",
	"left",
	"right",
	"down",
	"up" }

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
hs.hotkey.bind(shifopt, 'p', hs.spotify.playpause)
hs.hotkey.bind(f18, 'right', hs.spotify.next)
hs.hotkey.bind(f18, 'left', hs.spotify.previous)
