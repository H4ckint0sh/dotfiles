-- start quick open applications

local function open_app(names)
	return function()
		for _, name in pairs(names) do
			if hs.application.launchOrFocus(name) then
				return
			end
		end
	end
end

-- Hammerspoon will try to open applications with same order passed in as argument
-- If Microsoft Teams is opened then Spotify app will not open
-- and if Microsoft Teams is not found then Spotify will be opened so on and so forth
hs.hotkey.bind({ "alt", "shift" }, "A", open_app({ "Alacritty" }))
hs.hotkey.bind({ "alt", "shift" }, "S", open_app({ "Spotify" }))
-- hs.hotkey.bind({ "cmd", "shift" }, "D", open_app({ "Discord" }))
-- hs.hotkey.bind({ "cmd", "shift" }, "W", open_app({ "IntelliJ IDEA", "Webstorm" }))
-- hs.hotkey.bind({ "cmd", "shift" }, "P", open_app({ "Postman" }))

hs.hotkey.bind({ "alt", "shift" }, "T", open_app({ "Microsoft Teams" }))
hs.hotkey.bind({ "alt", "shift" }, "O", open_app({ "Microsoft Outlook" }))
hs.hotkey.bind({ "alt", "shift" }, "C", open_app({ "Google Chrome" }))
hs.hotkey.bind({ "alt", "shift" }, "V", open_app({ "Visual Studio Code" }))
