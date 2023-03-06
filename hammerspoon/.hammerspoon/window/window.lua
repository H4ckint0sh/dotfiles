-- Window management
-- Defines for window maximize toggler
-- local frameCache = {}
-- local logger = hs.logger.new("windows")

-- Resize current window
local function winresize(how)
	local win = hs.window.focusedWindow()
	-- local app = win:application():name()
	-- local windowLayout
	local newrect

	if how == "left" then
		newrect = hs.layout.left50
	elseif how == "right" then
		newrect = hs.layout.right50
	elseif how == "up" then
		newrect = { 0, 0, 1, 0.5 }
	elseif how == "down" then
		newrect = { 0, 0.5, 1, 0.5 }
	elseif how == "max" then
		newrect = hs.layout.maximized
	elseif how == "left_third" or how == "hthird-0" then
		newrect = { 0, 0, 1 / 3, 1 }
	elseif how == "middle_third_h" or how == "hthird-1" then
		newrect = { 1 / 3, 0, 1 / 3, 1 }
	elseif how == "right_third" or how == "hthird-2" then
		newrect = { 2 / 3, 0, 1 / 3, 1 }
	elseif how == "top_third" or how == "vthird-0" then
		newrect = { 0, 0, 1, 1 / 3 }
	elseif how == "middle_third_v" or how == "vthird-1" then
		newrect = { 0, 1 / 3, 1, 1 / 3 }
	elseif how == "center" then
		newrect = { 0.9, 0.9, 0.9, 0.9 }
	elseif how == "bottom_third" or how == "vthird-2" then
		newrect = { 0, 2 / 3, 1, 1 / 3 }
	end

	win:move(newrect)
end

local function winmovefocus(how)
	local win = hs.window.focusedWindow()
	if how == "up" then
		win:focusWindowNorth()
	elseif how == "down" then
		win:focusWindowSouth()
	elseif how == "left" then
		win:focusWindowWest()
	elseif how == "right" then
		win:focusWindowEast()
	end
end

-- Toggle a window between its normal size, and being maximized
-- local function toggle_window_maximized()
--   local win = hs.window.focusedWindow()
--   if frameCache[win:id()] then
--     win:setFrame(frameCache[win:id()])
--     frameCache[win:id()] = nil
--   else
--     frameCache[win:id()] = win:frame()
--     win:maximize()
--   end
-- end

-- Move between thirds of the screen
-- local function get_horizontal_third(win)
--   local frame = win:frame()
--   local screenframe = win:screen():frame()
--   local relframe = hs.geometry(frame.x - screenframe.x, frame.y - screenframe.y, frame.w, frame.h)
--   local third = math.floor(3.01 * relframe.x / screenframe.w)
--   logger.df("Screen frame: %s", screenframe)
--   logger.df("Window frame: %s, relframe %s is in horizontal third #%d", frame, relframe, third)
--   return third
-- end
--
-- local function get_vertical_third(win)
--   local frame = win:frame()
--   local screenframe = win:screen():frame()
--   local relframe = hs.geometry(frame.x - screenframe.x, frame.y - screenframe.y, frame.w, frame.h)
--   local third = math.floor(3.01 * relframe.y / screenframe.h)
--   logger.df("Screen frame: %s", screenframe)
--   logger.df("Window frame: %s, relframe %s is in vertical third #%d", frame, relframe, third)
--   return third
-- end
--
-- local function left_third()
--   local win = hs.window.focusedWindow()
--   local third = get_horizontal_third(win)
--   if third == 0 then
--     winresize("hthird-0")
--   else
--     winresize("hthird-" .. (third - 1))
--   end
-- end
--
-- local function right_third()
--   local win = hs.window.focusedWindow()
--   local third = get_horizontal_third(win)
--   if third == 2 then
--     winresize("hthird-2")
--   else
--     winresize("hthird-" .. (third + 1))
--   end
-- end
--
-- local function up_third()
--   local win = hs.window.focusedWindow()
--   local third = get_vertical_third(win)
--   if third == 0 then
--     winresize("vthird-0")
--   else
--     winresize("vthird-" .. (third - 1))
--   end
-- end
--
-- local function down_third()
--   local win = hs.window.focusedWindow()
--   local third = get_vertical_third(win)
--   if third == 2 then
--     winresize("vthird-2")
--   else
--     winresize("vthird-" .. (third + 1))
--   end
-- end

local function center()
	local win = hs.window.focusedWindow()
	winresize("center")
	win:centerOnScreen()
end

-------- Key bindings
local shift_cmd = { "shift", "cmd" }

-- Halves of the screen
hs.hotkey.bind(shift_cmd, "H", hs.fnutils.partial(winresize, "left"))
hs.hotkey.bind(shift_cmd, "L", hs.fnutils.partial(winresize, "right"))
hs.hotkey.bind(shift_cmd, "K", hs.fnutils.partial(winresize, "up"))
hs.hotkey.bind(shift_cmd, "J", hs.fnutils.partial(winresize, "down"))
-- Center of the screen
hs.hotkey.bind(shift_cmd, "C", center)
-- Maximized
hs.hotkey.bind(shift_cmd, "F", hs.fnutils.partial(winresize, "max"))

-- Thirds of the screen
-- hs.hotkey.bind({ "ctrl", "alt" }, "H", left_third)
-- hs.hotkey.bind({ "ctrl", "alt" }, "L", right_third)
-- hs.hotkey.bind({ "ctrl", "alt" }, "K", up_third)
-- hs.hotkey.bind({ "ctrl", "alt" }, "J", down_third)

local ctrl_alt_cmd = { "ctrl", "alt", "cmd" }

-- Move between screens
hs.hotkey.bind(ctrl_alt_cmd, "H", hs.fnutils.partial(winmovefocus, "left"))
hs.hotkey.bind(ctrl_alt_cmd, "L", hs.fnutils.partial(winmovefocus, "right"))
hs.hotkey.bind(ctrl_alt_cmd, "K", hs.fnutils.partial(winmovefocus, "up"))
hs.hotkey.bind(ctrl_alt_cmd, "J", hs.fnutils.partial(winmovefocus, "down"))

hs.hotkey.bind(ctrl_alt_cmd, "n", function()
	-- get the focused window
	local win = hs.window.focusedWindow()
	-- get the screen where the focused window is displayed, a.k.a. current screen
	local screen = win:screen()
	-- compute the unitRect of the focused window relative to the current screen
	-- and move the window to the next screen setting the same unitRect
	win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)
