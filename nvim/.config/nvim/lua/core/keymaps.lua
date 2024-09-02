local keymap = vim.keymap

keymap.set("v", "<S-PageDown>", ":m '>+1<CR>gv=gv") -- Move Line Down in Visual Mode
keymap.set("v", "<S-PageUp>", ":m '<-2<CR>gv=gv") -- Move Line Up in Visual Mode
keymap.set("n", "<S-PageDown>", ":m .+1<CR>==") -- Move Line Down in Normal Mode
keymap.set("n", "<S-PageUp>", ":m .-2<CR>==") -- Move Line Up in Normal Mode

-- init.lua
-- Move line up
keymap.set("n", "<A-u>", ":m .-2<cr>==")
keymap.set("i", "<A-u>", "<esc>:m .-2<cr>==gi")
keymap.set("v", "<A-u>", ":m '<-2<CR>gv=gv")

-- Move line down
keymap.set("n", "<A-d>", ":m .+1<CR>==")
keymap.set("i", "<A-d>", "<Esc>:m .+1<CR>==gi")
keymap.set("v", "<A-d>", ":m '>+1<CR>gv=gv")

-- Select whole file
keymap.set("n", "<leader>sa", "ggVG")

-- Keep stuff centred while moving around
keymap.set("n", "*", "*zzzv")
keymap.set("n", "#", "#zzzv")
keymap.set("n", ",", ",zzzv")
keymap.set("n", ";", ";zzzv")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Some fun register stuff
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+y$')
keymap.set("v", "<leader>d", '"_d')
keymap.set("n", "<leader>x", '"_x')
keymap.set("n", "<leader>p", '"_dP')

-- Keep things highlighted after moving with < and >
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- init.lua
-- Duplicate line up
keymap.set("n", "<A-S-u>", "yypk")
keymap.set("v", "<A-S-u>", "yP`[V`]")

-- Duplicate line down
keymap.set("n", "<A-S-d>", "yyp")
keymap.set("v", "<A-S-d>", "y`>pgv")

-- move to first non-blank character
keymap.set("n", "<BS>", "^")

-- Highlight to end of line
keymap.set("n", "L", "vg_")

-- paste over whole file
keymap.set("n", "<leader>v", "ggVGp")

-- Remove highlights
keymap.set("n", "<CR>", ":noh<CR><CR>")

-- Buffers
keymap.set("n", "<leader>x", ":bd<CR>")

-- Redo
keymap.set("n", "<S-u>", ":redo<CR>", { silent = true })

-- Save
keymap.set("n", "<leader>w", ":w<CR>", { silent = true })

keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is.enable)
end)

-- Search
keymap.set("n", "R", ":%s/\\v/g<left><left>", { silent = false }) -- replace
keymap.set("n", "ss", ":s/", { silent = false }) -- search and replace
keymap.set("n", "SS", ":%s/\\v", { silent = false }) -- search and replace
keymap.set("v", "<leader><C-r>", ":s/\\%V") -- Search only in visual selection usingb%V atom
keymap.set("v", "<C-r>", '"hy:%s/\\v<C-r>h//g<left><left>', { silent = false }) -- change selection

-- General keymaps
keymap.set("i", "jk", "<ESC>") -- exit insert mode with jk
keymap.set("i", "ii", "<ESC>") -- exit insert mode with ii
keymap.set("n", "<leader>%", "ggVG") -- exit insert mode with ii
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-") -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+") -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5") -- make split windows width bigger
keymap.set("n", "<leader>sh", "<C-w><5") -- make split windows width smaller

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>") -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c") -- next diff hunk
keymap.set("n", "<leader>cp", "[c") -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle maximize tab

-- got to previuos active tab
keymap.set("n", "<leader>#", ":b#<CR>")

-- Nvim-tree
keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<leader>er", ":NvimTreeFocus<CR>") -- toggle focus to file explorer
keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>") -- find file in file explorer

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame

-- Harpoon
keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)
keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
keymap.set("n", "<leader>h1", function()
	require("harpoon.ui").nav_file(1)
end)
keymap.set("n", "<leader>h2", function()
	require("harpoon.ui").nav_file(2)
end)
keymap.set("n", "<leader>h3", function()
	require("harpoon.ui").nav_file(3)
end)
keymap.set("n", "<leader>h4", function()
	require("harpoon.ui").nav_file(4)
end)
keymap.set("n", "<leader>h5", function()
	require("harpoon.ui").nav_file(5)
end)
keymap.set("n", "<leader>h6", function()
	require("harpoon.ui").nav_file(6)
end)
keymap.set("n", "<leader>h7", function()
	require("harpoon.ui").nav_file(7)
end)
keymap.set("n", "<leader>h8", function()
	require("harpoon.ui").nav_file(8)
end)
keymap.set("n", "<leader>h9", function()
	require("harpoon.ui").nav_file(9)
end)

-- Keybindings for LSP functionalities
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>") -- Go to Definition
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>") -- Go to Implementation
keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>") -- Rename Symbol
keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- Code Actions
keymap.set("n", "<leader>gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>") -- Type Definition
keymap.set("n", "<leader>sh", "<cmd>lua vim.lsp.buf.signature_help()<CR>") -- Signature Help
keymap.set("n", "<leader>f", require("fzf-lua").files, { desc = "Fzf Files" })
keymap.set("n", "<leader>R", require("fzf-lua").registers, { desc = "Registers" })
keymap.set("n", "<leader>m", require("fzf-lua").marks, { desc = "Marks" })
keymap.set("n", "<leader>h", require("fzf-lua").oldfiles, { desc = "Recent files" })
keymap.set("n", "<leader>t", require("fzf-lua").live_grep, { desc = "Fzf Grep" }, { silent = true })
keymap.set("n", "<leader>b", require("fzf-lua").buffers, { desc = "Fzf Buffers" })
keymap.set("n", "<leader>j", require("fzf-lua").helptags, { desc = "Help Tags" })
keymap.set("n", "<leader>gc", require("fzf-lua").git_bcommits, { desc = "Browse File Commits" })
-- keymap.set("n", "<leader>gs", require("fzf-lua").git_status, { desc = "Git Status" })
keymap.set("n", "<leader>d", "<cmd>FzfLua lsp_document_diagnostics<CR>")
keymap.set("n", "<leader>D", "<cmd>FzfLua lsp_workspace_diagnostics<CR>")
keymap.set("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", {})
keymap.set("n", "<leader>gs", "<cmd>FzfLua lsp_document_symbols<CR>", {})
keymap.set("n", "<leader>gr", "<cmd>FzfLua lsp_references<CR>", {})
keymap.set("n", "<leader>'", "<cmd>FzfLua resume<cr>", { desc = "Resume" })

-- load the session for the current directory
keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end)

-- select a session to load
keymap.set("n", "<leader>S", function()
	require("persistence").select()
end)

-- load the last session
keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end)

-- stop Persistence => session won't be saved on exit
keymap.set("n", "<leader>qd", function()
	require("persistence").stop()
end)
