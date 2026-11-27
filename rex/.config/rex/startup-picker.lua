-- Opens the "Sessions" picker (the new_session action in init.lua, cmd+n)
-- every time the Rex app starts. Rex only runs rex.on handlers in a script
-- run with `rex do`, so ~/bin/rex-startup-picker keeps this running as a
-- launchd agent:  rex do --all ~/.config/rex/startup-picker.lua
local REX = os.getenv("HOME")
  .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"
local last_pid

rex.on("client_joined", function(_, ev)
  local c = ev.client or {}
  if not (c.info and c.info.kind == "app") then return end
  local pid = c.principal and c.principal.pid
  if pid ~= nil and pid == last_pid then return end -- the same app reconnecting
  last_pid = pid
  -- In the background, after the window is up. Skip it when a picker is
  -- already open, e.g. ~/bin/rex-session-init's in a brand-new session.
  rex.exec({ "/bin/sh", "-c", [[
    ( sleep 2
      pgrep -f "rex do .*new_session" >/dev/null || "$0" do new_session
    ) >/dev/null 2>&1 &
  ]], REX })
end)
