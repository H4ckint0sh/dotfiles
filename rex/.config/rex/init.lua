-- Rex configuration (terminal multiplexer; replaces tmux)
--
-- Two layers of keys, same as the old Ghostty + tmux setup:
--   * cmd+<key>     the keys Ghostty used to translate into tmux prefix sequences
--   * ctrl+b><key>  the tmux prefix itself, for the binds in tmux.conf and the
--                   tmux defaults that were in use
--
-- Reload with cmd+r, ctrl+b>r, or `rex config reload`.
-- Check with `rex config check` and `rex keymap`.

local HOME = os.getenv("HOME")
local BIN = HOME .. "/bin"
local SHELL = "com.superlogical.terminal.shell"
local P = "ctrl+b" -- prefix, kept from tmux (C-b)

-- Appearance, applied by the "appearance" action (`rex do appearance` or the
-- command palette). Rex stores these in its app settings.
local FONT = { 
  -- MonoLisa with Zed's buffer_font_features (ss02 script italics, zero)
  -- built in, since Rex can't turn features on. Build it with ~/bin/rex-font.
  family = "MonoLisa Rex",
  size = 13,
  line_height = 10, -- extra line spacing, in percent
  style = "Medium", -- weight; MonoLisa's default face is too thin
  italic = true, -- italic face for italic text (nvim comments/keywords, like Zed)
  bold = true,
  ligatures = true,
}
local THEME = HOME .. "/.config/rex/themes/Nord"

-- Tab bar like the old tmux status line: tabs across the top, always shown.
local TABS = {
  layout = "above", -- above | left | right
  toolbar = "always_show", -- always_show | on_hover | hidden
  density = "compact", -- compact | comfortable: smaller toolbar, tabs and spacing
  fill = false, -- true stretches tabs to fill the bar
}

-- ============================================================================
-- Helpers
-- ============================================================================

-- Open a command in a floating layer over the current window, like
-- `display-popup` / `fzf-tmux -p`. The layer closes when the command exits.
local function popup(ctx, argv, opts)
  opts = opts or {}
  return rex.call("session.new_layer", {
    session_id = ctx.session_id,
    bounds = opts.bounds or { 0.1, 0.1, 0.8, 0.8 },
    focus = true,
    layout = {
      block = {
        flavor = SHELL,
        label = opts.label,
        options = {
          command = argv,
          path_prepend = { BIN, "/opt/homebrew/bin" },
        },
      },
    },
  })
end

-- Foreground process of a block: { name = "zsh", pid = 123, cwd = "..." }.
local function foreground(ctx)
  if not (ctx.session_id and ctx.block_id) then
    return nil
  end
  local p = rex.call("com.superlogical.terminal.process", {
    session_id = ctx.session_id,
    block_id = ctx.block_id,
  })
  return p and p.foreground
end

-- Same test as tmux.conf's is_vim_or_fzf: any running process on the pane's
-- tty that is vim/nvim or fzf. Checking the whole tty (not just the foreground
-- program) catches fzf started from zsh widgets such as fzf-tab, ctrl+t, ctrl+r.
local IS_VIM_OR_FZF = [[
tty=$(ps -o tty= -p "$1" 2>/dev/null | tr -d ' ')
[ -n "$tty" ] || exit 1
ps -o state= -o comm= -t "$tty" |
  grep -iqE '^[^TXZ ]+ +(\S+/)?g?(view|n?vim?x?)(diff)?$|fzf'
]]

local function vim_or_fzf_running(ctx)
  local fg = foreground(ctx)
  if not (fg and fg.pid) then
    return false
  end
  local r = rex.exec({ "/bin/sh", "-c", IS_VIM_OR_FZF, "sh", tostring(fg.pid) }, { timeout = 2 })
  return r ~= nil and r.ok == true
end

-- ============================================================================
-- Custom actions
-- ============================================================================

-- Resize in small steps (Rex's pane.resize jumps too far): move the border of
-- the nearest split around the focused pane. left/up move it left/up,
-- right/down move it right/down, like tmux resize-pane.
local RESIZE_STEP = 0.01 -- fraction of the split's size per key press

local function first_block(node)
  while node.split do
    node = node.split.before
  end
  return node.block_id
end

-- The innermost split of the given direction that contains block.
local function find_split(node, block, direction)
  if not node.split then
    return nil, node.block_id == block
  end
  for _, side in ipairs({ "before", "after" }) do
    local found, here = find_split(node.split[side], block, direction)
    if found then
      return found
    end
    if here then
      return node.split.direction == direction and node.split or nil, true
    end
  end
  return nil, false
end

rex.action({
  name = "resize_pane",
  title = "Resize Pane (small steps)",
  args = { direction = "string" },
  run = function(ctx, args)
    local axis = (args.direction == "left" or args.direction == "right") and "horizontal" or "vertical"
    local sign = (args.direction == "left" or args.direction == "up") and -1 or 1
    local view = rex.call("session.view", { session_id = ctx.session_id })
    for _, window in ipairs(view.windows or {}) do
      for _, layer in ipairs(window.layers or {}) do
        local split = layer.layout and find_split(layer.layout, ctx.block_id, axis)
        if split then
          local ratio = math.min(0.95, math.max(0.05, split.ratio + sign * RESIZE_STEP))
          rex.call("session.resize_pane", {
            session_id = ctx.session_id,
            direction = axis,
            before_block_id = first_block(split.before),
            after_block_id = first_block(split.after),
            ratio = ratio,
          })
          return
        end
      end
    end
  end,
})

-- Close sessions from a list (the old `k` picker's ctrl-d). Rex's own
-- session switcher (cmd+k) has no close key: what you type there filters.
-- Tick the sessions to close, then press Close.
local function picked_ids(result)
  if type(result) == "string" then
    return { result }
  elseif type(result) == "table" then
    return result.ids or (result.id and { result.id }) or result
  end
  return {}
end

rex.action({
  name = "close_sessions",
  title = "Close Sessions...",
  run = function(ctx)
    local items = {}
    for _, s in ipairs(rex.call("session.list", {}).sessions or {}) do
      table.insert(items, {
        id = s.session_id,
        title = s.label,
        icon = "terminal",
        detail = s.session_id == ctx.session_id and "current" or nil,
      })
    end
    local result = rex.ui.pick({ title = "Close sessions", confirm = "Close", multiple = true, items = items })
    for _, id in ipairs(picked_ids(result)) do
      rex.call("session.destroy", { session_id = id })
    end
  end,
})

-- tmux.conf: bind -n C-q if-shell "$is_vim_or_fzf" 'send-keys C-q' 'kill-pane'
rex.action({
  name = "close_pane_unless_vim",
  title = "Close Pane (vim aware)",
  run = function(ctx)
    if vim_or_fzf_running(ctx) then
      rex.client.queue("pane.send_key", { key = "ctrl+q" })
    else
      rex.client.queue("pane.close")
    end
  end,
})

-- ============================================================================
-- Sessions: Rex's built-in session management
--   cmd+n            New Project Session: a Rex picker of ~/projects (or type
--                    a name), then nvim left 75% + two shells right 25%
--   cmd+k            Rex session switcher (its "New Session" uses the flow below)
--   cmd+ctrl+n       Rex's plain New Session. ~/bin/rex-session-init, run from
--                    ~/.zshrc when a shell is the only pane of a new session,
--                    asks for a directory with fzf and builds the same layout.
-- ============================================================================

-- New project session (cmd+n): pick a directory in ~/projects or type a name
-- (a plain name means ~/projects/NAME, ~/... and /... are used as they are;
-- a missing directory is created), then open a session named after it:
--   left 75%: nvim   right 25%: two stacked shells
-- `rex do new_session dir=NAME` does the same without the prompt.
-- With here=true it lays out the calling session instead of making a new one
-- and leaves starting nvim to the caller: ~/bin/rex-session-init runs it this
-- way for a brand-new session (first launch, or "New Session" in cmd+k).
local function project_dirs()
  local r = rex.exec({ "/usr/bin/find", HOME .. "/projects", "-mindepth", "1", "-maxdepth", "1",
    "-type", "d", "-not", "-name", ".*" }, { timeout = 5 })
  local dirs = {}
  for path in ((r and r.stdout) or ""):gmatch("[^\n]+") do
    table.insert(dirs, path)
  end
  table.sort(dirs, function(a, b) return a:lower() < b:lower() end)
  return dirs
end

local function list_sessions()
  local r = rex.call("session.list", {})
  return (r and r.sessions) or {}
end

-- The session Rex opens at launch (or "New Session"): one window, one shell.
local function is_blank_session(session_id)
  local v = session_id and rex.call("session.view", { session_id = session_id })
  local w = v and v.windows
  return w ~= nil and #w == 1 and w[1].layers and #w[1].layers == 1
    and w[1].layers[1].layout and w[1].layers[1].layout.block_id ~= nil
end

local function resolve_dir(name)
  name = name:match("^%s*(.-)%s*$")
  if name == "" then return nil end
  if name == "~" then return HOME end
  if name:sub(1, 2) == "~/" then return HOME .. name:sub(2) end
  if name:sub(1, 1) == "/" then return name end
  return HOME .. "/projects/" .. name
end

-- cmd+1..9: go to the Nth open session (the numbers shown in the cmd+n list)
rex.action({
  name = "goto_session",
  title = "Go to Session N",
  args = { index = "integer" },
  run = function(_, args)
    local s = list_sessions()[args.index]
    if s then rex.client.queue("session.select", { session_id = s.session_id }) end
  end,
})

rex.action({
  name = "new_session",
  title = "New Project Session",
  description = "Pick or type a project directory and open nvim with two shells beside it",
  keywords = "project session new directory folder nvim",
  args = { dir = "string?", here = "boolean?" },
  run = function(ctx, args)
    local dir = args.dir and resolve_dir(args.dir)
    if not dir then
      -- open sessions first (numbered like cmd+1..9), then ~/projects
      local items = {}
      for i, s in ipairs(list_sessions()) do
        if not (args.here and s.session_id == ctx.session_id) then
          local key = i <= 9 and ("⌘" .. i) or nil
          local current = (not args.here and s.session_id == ctx.session_id) and "current" or nil
          table.insert(items, {
            id = s.session_id,
            title = s.label,
            subtitle = "open session",
            icon = "terminal",
            detail = current and key and (key .. "  current") or current or key,
          })
        end
      end
      table.insert(items, { id = HOME .. "/.dotfiles", title = ".dotfiles", subtitle = "~/.dotfiles", icon = "gear" })
      table.insert(items, { id = "close_all", title = "Close all sessions", subtitle = "asks first", icon = "star" })
      for _, path in ipairs(project_dirs()) do
        table.insert(items, { id = path, title = path:match("([^/]+)$"), icon = "folder" })
      end
      local choice, why
      -- at app launch the shell can ask before the window is ready for prompts
      for _ = 1, 20 do
        choice, why = rex.ui.pick({
          title = "Sessions",
          placeholder = "Open a session or project, or type a name to create one in ~/projects",
          confirm = "Open",
          items = items,
          allow_other = true,
        })
        if choice ~= nil or not (why == "no_client" or why == "unsupported" or why == "busy") then break end
        rex.exec({ "/bin/sleep", "0.5" })
      end
      if choice == nil then
        if why ~= "cancelled" then rex.log("warn", "new_session: " .. tostring(why)) end
        return { cancelled = why }
      end
      if choice == "close_all" then
        local sessions = list_sessions()
        local sure = rex.ui.pick({
          title = "Close all " .. #sessions .. " sessions?",
          confirm = "Choose",
          items = {
            { id = "no", title = "No, keep them" },
            { id = "yes", title = "Yes, close every session", subtitle = "Rex then opens a new one with this picker" },
          },
        })
        if sure ~= "yes" then return end
        -- the session this ran from goes last, so the action isn't cut short
        for _, sess in ipairs(sessions) do
          if sess.session_id ~= ctx.session_id then
            rex.call("session.destroy", { session_id = sess.session_id })
          end
        end
        if ctx.session_id then rex.call("session.destroy", { session_id = ctx.session_id }) end
        return { closed = #sessions }
      end
      if type(choice) == "string" and choice:match("^session:") then
        rex.client.queue("session.select", { session_id = choice })
        if ctx.session_id and (args.here or is_blank_session(ctx.session_id)) then
          -- the empty session Rex opened is not needed
          rex.call("session.destroy", { session_id = ctx.session_id })
        end
        return { session_id = choice }
      end
      dir = type(choice) == "table" and resolve_dir(choice.text) or choice
      if not dir then return end
    end
    dir = dir:gsub("/+$", "")
    local made = rex.exec({ "/bin/mkdir", "-p", dir })
    if not (made and made.ok) then
      error("new_session: can't create " .. dir, 0)
    end
    local name = dir:match("([^/]+)$") or dir

    -- a session for this directory is already open: go there instead
    for _, sess in ipairs(list_sessions()) do
      if sess.label == name and sess.session_id ~= ctx.session_id then
        rex.client.queue("session.select", { session_id = sess.session_id })
        if args.here or is_blank_session(ctx.session_id) then
          rex.call("session.destroy", { session_id = ctx.session_id })
        end
        return { session_id = sess.session_id }
      end
    end

    local function shell(opts)
      opts.cwd = dir
      return rex.layout.block({ flavor = SHELL, options = opts })
    end
    local function mark_named(session_id)
      -- tell the zsh session-naming hook (~/.zshrc) this session is named
      rex.exec({ "/bin/sh", "-c", 'mkdir -p "$1" && printf "%s\\n" "$2" > "$1/$3"', "sh",
        HOME .. "/.cache/rex/session-names", name, (session_id:gsub("^session:", "")) })
    end

    if args.here and ctx.session_id and ctx.block_id then
      local sid = ctx.session_id
      rex.call("session.set_label", { session_id = sid, label = name })
      local view = rex.call("session.view", { session_id = sid })
      local window = view and view.windows and view.windows[1]
      if window then
        rex.call("session.set_window_label", { session_id = sid, window_id = window.window_id, label = name })
      end
      local ok, err = rex.call("session.new_split", {
        session_id = sid, anchor_id = ctx.block_id, direction = "horizontal", side = "after",
        ratio = 0.75, layout = rex.layout.vertical(0.5, shell({}), shell({})),
      })
      if not ok then error("new_session: " .. tostring(err), 0) end
      mark_named(sid)
      return { session_id = sid, dir = dir }
    end
    local r, err = rex.call("session.create", {
      label = name,
      initial_windows = { {
        window_label = name,
        -- nvim is typed into a login shell so it gets your PATH and env;
        -- nvim-pane (~/.zshrc) clears the scrollback first: no Rex scrollbar
        -- (the leading space keeps it out of the shell history)
        layout = rex.layout.horizontal(0.75, shell({ initial_input = " nvim-pane\n" }),
          rex.layout.vertical(0.5, shell({}), shell({}))),
      } },
    })
    if not r then error("new_session: " .. tostring(err), 0) end
    mark_named(r.session_id)
    rex.client.queue("session.select", { session_id = r.session_id })
    -- cmd+n from the empty session Rex opened at launch: it's not needed
    if ctx.session_id and is_blank_session(ctx.session_id) then
      rex.call("session.destroy", { session_id = ctx.session_id })
    end
    return { session_id = r.session_id, dir = dir }
  end,
})

-- tmux.conf: bind -r i run-shell "tmux neww tmux-cht.sh"
rex.action({
  name = "cheat_sheet",
  title = "cht.sh Cheat Sheet",
  run = function(ctx)
    popup(ctx, { BIN .. "/rex-cht" }, { label = "cht.sh", bounds = { 0.2, 0.15, 0.6, 0.7 } })
  end,
})

-- tmux-fzf-url (prefix u): pick a URL from the focused pane and open it.
rex.action({
  name = "fzf_url",
  title = "Open URL from Pane",
  run = function(ctx)
    popup(ctx, { BIN .. "/rex-fzf-url", ctx.session_id or "", ctx.block_id or "" }, {
      label = "Open URL",
      bounds = { 0.2, 0.35, 0.6, 0.3 },
    })
  end,
})

-- Nord theme and the FONT settings above.
rex.action({
  name = "appearance",
  title = "Apply Nord Theme, Font and Tab Bar",
  run = function()
    rex.client.queue("client.theme.import", { path = THEME })
    rex.client.queue("client.setting.interface.appearance.scheme", { value = "dark" })
    rex.client.queue("client.setting.interface.toolbar.layout", { value = TABS.layout })
    rex.client.queue("client.setting.interface.toolbar.auto_hide_toolbar", { value = TABS.toolbar })
    rex.client.queue("client.setting.interface.panes.density", { value = TABS.density })
    rex.client.queue("client.setting.interface.tab_behavior.fill", { value = TABS.fill })
    rex.client.queue("client.setting.terminal.typography.font", { value = FONT.family })
    rex.client.queue("client.setting.terminal.typography.size", { value = FONT.size })
    rex.client.queue("client.setting.terminal.typography.line_height", { value = FONT.line_height })
    rex.client.queue("client.setting.terminal.typography.style", { value = FONT.style })
    local faces = (FONT.bold and FONT.italic) and "both" or FONT.bold and "bold_only" or FONT.italic and "italic_only" or "neither"
    rex.client.queue("client.setting.terminal.advanced_fonts.bold_italic", { value = faces })
    rex.client.queue("client.setting.terminal.advanced_fonts.ligatures", { value = FONT.ligatures })
  end,
})

-- ============================================================================
-- Prefix (ctrl+b) bindings
-- ============================================================================

-- Programs that use ctrl+b themselves still get it with ctrl+b ctrl+b
-- (tmux default: bind C-b send-prefix).
rex.bind(P .. ">ctrl+b", "pane.send_key", { key = "ctrl+b" })

-- tmux.conf: bind r source-file ... ; display-message "Config Reloaded."
rex.bind(P .. ">r", "client.config.reload")

-- tmux.conf: bind-key -r i run-shell "tmux neww tmux-cht.sh"
rex.bind(P .. ">i", "cheat_sheet")

-- tmux.conf: bind-key & kill-window (no confirm)
rex.bind(P .. ">shift+7", "client.tab.close")
-- tmux.conf: bind-key x kill-pane (no confirm)
rex.bind(P .. ">x", "pane.close")

-- tmux.conf: bind L (last session)
rex.bind(P .. ">shift+l", "client.navigate.back")

-- tmux.conf: bind-key s run-shell -b tmux-switch-pane.sh
-- Rex's Go to Anything lists every session, tab and pane.
rex.bind(P .. ">s", "pane.go_to")

-- tmux.conf: bind-key K (session picker) -> Rex session switcher
rex.bind(P .. ">shift+k", "session.switch")
rex.bind(P .. ">shift+x", "close_sessions")                       -- old k picker: ctrl-d kill session

-- new-session, laid out as nvim + terminal
rex.bind(P .. ">shift+n", "new_session")

-- tmux-fzf-url default key
rex.bind(P .. ">u", "fzf_url")

-- tmux defaults that were in use
rex.bind(P .. ">c", "client.tab.new")                                -- new-window
rex.bind(P .. ">shift+'", "pane.split", { direction = "down" })      -- "  split-window
rex.bind(P .. ">shift+5", "pane.split", { direction = "right" })     -- %  split-window -h
rex.bind(P .. ">n", "client.tab.next")                               -- next-window
rex.bind(P .. ">p", "client.tab.previous")                           -- previous-window
rex.bind(P .. ">z", "pane.zoom")                                     -- resize-pane -Z
rex.bind(P .. ">o", "pane.focus_next")                               -- select-pane -t :.+
rex.bind(P .. ">w", "pane.go_to")                                    -- choose-tree
rex.bind(P .. ">[", "pane.copy_mode.enter")                          -- copy-mode
rex.bind(P .. ">,", "client.tab.rename")                             -- rename-window
rex.bind(P .. ">shift+1", "pane.move_to_new_tab")                    -- !  break-pane
rex.bind(P .. ">shift+9", "session.previous")                        -- (  switch-client -p
rex.bind(P .. ">shift+0", "session.next")                            -- )  switch-client -n
rex.bind(P .. ">left", "pane.focus", { direction = "left" })
rex.bind(P .. ">right", "pane.focus", { direction = "right" })
rex.bind(P .. ">up", "pane.focus", { direction = "up" })
rex.bind(P .. ">down", "pane.focus", { direction = "down" })
rex.bind(P .. ">ctrl+left", "resize_pane", { direction = "left" })
rex.bind(P .. ">ctrl+right", "resize_pane", { direction = "right" })
rex.bind(P .. ">ctrl+up", "resize_pane", { direction = "up" })
rex.bind(P .. ">ctrl+down", "resize_pane", { direction = "down" })
-- select-window -t :0..9 (tmux windows start at 0, Rex tabs at 1)
for i = 0, 9 do
  rex.bind(P .. ">" .. i, "client.tab.goto", { index = i + 1 })
end

-- ============================================================================
-- No-prefix bindings (tmux `bind -n`)
-- ============================================================================

-- Pane navigation: hyper (caps lock, Karabiner) + h/j/k/l moves between Rex panes, so
-- ctrl+h/j/k/l are left to nvim and the shell
rex.bind("ctrl+alt+shift+cmd+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+alt+shift+cmd+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+alt+shift+cmd+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+alt+shift+cmd+l", "pane.focus", { direction = "right" })
rex.bind("ctrl+q", "close_pane_unless_vim")

-- ============================================================================
-- cmd keys (the ghostty `keybind = cmd+x=text:\x02...` lines)
-- ============================================================================

rex.bind("cmd+alt+left", "client.tab.previous")                  -- C-b p
rex.bind("cmd+alt+right", "client.tab.next")                     -- C-b n
-- cmd+k: Rex's session switcher (Rex default, not rebound)
rex.bind("cmd+shift+k", "close_sessions")                         -- pick sessions to close
rex.bind("cmd+w", "session.close")                                -- close this session (cmd+k, pick, enter, cmd+w)
rex.bind("cmd+ctrl+n", "session.new")                            -- Rex New Session (plain; ~/bin/rex-session-init asks for a dir)
rex.bind("cmd+l", "client.navigate.back")                        -- C-b L (last session)
rex.bind("cmd+n", "new_session")                                 -- New Project Session picker
for i = 1, 9 do
  rex.bind("cmd+" .. i, "goto_session", { index = i })             -- Nth session (tabs: C-b 1..9)
end
rex.bind("cmd+shift+n", "pane.split", { direction = "right" })   -- C-b %
rex.bind("cmd+s", "pane.go_to")                                  -- C-b s
rex.bind("cmd+i", "cheat_sheet")                                 -- C-b i
rex.bind("cmd+z", "pane.zoom")                                   -- C-b z
rex.bind("cmd+o", "pane.focus_next")                             -- C-b o
rex.bind("cmd+r", "client.config.reload")                        -- C-b r / ghostty reload_config
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("cmd+" .. dir, "resize_pane", { direction = dir })     -- C-b C-arrows: resize pane
end
-- Already Rex defaults: cmd+t new tab (C-b c). cmd+1..9 now go to sessions; tabs: C-b 1..9.
-- cmd+w (Rex: close pane) now closes the session; close a pane with C-b x or ctrl+q.
