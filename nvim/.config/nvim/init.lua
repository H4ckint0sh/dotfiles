require("core.performance")

require("core.options")

-- lazy
require("core.lazy")

-- Custom
require("custom.session") -- Substitutes in the statusline
require("custom.statusline") -- Substitutes in the statusline

-- These are not Loaded by lazy.nvim
require("core.autocmds")
require("core.keymaps")
require("custom.rex_navigator") -- ctrl+h/j/k/l across nvim splits and Rex panes
